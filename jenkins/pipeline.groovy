/*
 * Check a folder if changed in the latest commit.
 * Returns true if changed, or false if no changes.
 * @version 1.0.0
 */

boolean isChanged(path) {
    try {
        // git diff will return 1 for changes (failure) which is caught in catch, or
        // 0 meaning no changes
        sh "git diff --quiet --exit-code HEAD~1..HEAD ${path}"
        return false
    } catch (ignored) {
        return true
    }
}

def build(projs, envs = ["test"], group = "emernet.cn") {
    env.DEVOPS_WORKSPACE = "${env.WORKSPACE}/dists"

    env.DATE_TAG = new Date().format("yyyy-MM-dd")

    for (int i = 0; i < projs.size(); i++) {
        def proj = projs.get(i)
        if (!isChanged(proj)) {
            continue
        }
        // only build once for every environment
        boolean buildOnce = false
        for (int j = 0; j < envs.size(); j++) {
            def deployEnv = envs.get(j)
            // only deploy to non test env for master branch
            if (deployEnv.toString() != "test") {
                if (env.BRANCH_NAME.toString() != "master") {
                    continue
                }
            }
            env.DEPLOY_ENV = "${deployEnv}"
            load "${env.DEVOPS_WORKSPACE}/jenkins/config/${group}/env.${env.DEPLOY_ENV}.groovy"

            dir(proj) {
                stage("build-docker-${proj}") {
                    if (!buildOnce) {
                        if (fileExists("build.gradle")) {
                            buildOnce = true
                            withDockerContainer(image: 'gradle:5.4.1-jdk8', args: '-v gradle_cache:/home/gradle/.gradle -v /usr/bin/envsubst:/usr/bin/envsubst') {
                                sh '$DEVOPS_WORKSPACE/jenkins/scripts/build-gradle.sh'
                            }
                        }
                        if (fileExists("pom.xml")) {
                            buildOnce = true
                            withDockerContainer(image: 'maven:3-jdk-8', args: '-v maven_cache:/root/.m2 -v /usr/bin/envsubst:/usr/bin/envsubst') {
                                sh '$DEVOPS_WORKSPACE/jenkins/scripts/build-maven.sh'
                            }
                        }
                        if (fileExists("package.json")) {
                            buildOnce = false
                            withDockerContainer(image: 'node:lts', args: '-v /usr/bin/envsubst:/usr/bin/envsubst') {
                                sh '$DEVOPS_WORKSPACE/jenkins/scripts/build-npm.sh'
                            }
                        }

                        env.DOCKER_IMAGE = sh(script: 'source $DEVOPS_WORKSPACE/env; echo $DOCKER_IMAGE', returnStdout: true)
                        dir("docker") {
                            sh '$DEVOPS_WORKSPACE/jenkins/scripts/build-docker.sh'
                        }
                    }
                }

                switch (env.DEPLOY_MODE) {
                    case "docker-native":
                        stage("deploy-docker-native-${proj}-${deployEnv}") {
                            sh '$DEVOPS_WORKSPACE/jenkins/scripts/deploy-docker-native.sh'
                        }
                        break;
                    case "helm":
                        stage("deploy-helm-${proj}-${deployEnv}") {
                            dir("helm") {
                                sh '$DEVOPS_WORKSPACE/jenkins/scripts/gen-helm.sh'
                                sh '$DEVOPS_WORKSPACE/jenkins/scripts/deploy-helm.sh'
                            }
                        }
                        break;
                }

            }
        }
    }
}

return this