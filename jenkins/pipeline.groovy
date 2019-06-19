def build(projs) {
    def envs = ["prod"]
    for (int i = 0; i < projs.size(); i++) {
        def proj = projs.get(i)
        dir(proj) {
            stage("build-docker-${proj}") {
                if (fileExists("build.gradle")) {
                    withDockerContainer(image: 'gradle:5.4.1-jdk8', args: '-v gradle_cache:/home/gradle/.gradle -v /usr/bin/envsubst:/usr/bin/envsubst') {
                        sh '$WORKSPACE/dists/jenkins/scripts/build-gradle.sh'
                    }
                }
                if (fileExists("pom.xml")) {
                    withDockerContainer(image: 'maven:3-jdk-8', args: '-v maven_cache:/root/.m2 -v /usr/bin/envsubst:/usr/bin/envsubst') {
                        sh '$WORKSPACE/dists/jenkins/scripts/build-maven.sh'
                    }
                }
                env.DOCKER_IMAGE = sh(script: 'source ./env; echo $DOCKER_IMAGE', returnStdout: true)

                dir("docker") {
                    sh 'docker login $DOCKER_SERVER'
                    sh 'docker build -t $DOCKER_IMAGE .'
                    sh 'docker push $DOCKER_IMAGE'
                    sh 'docker image rm $DOCKER_IMAGE'
                }
            }

            for (int j = 0; j < projs.size(); j++) {
                def deployEnv = envs.get(j)
                stage("deploy-helm-${proj}-${deployEnv}") {
                    env.DEPLOY_SERVER = "kubernetes-admin@kubernetes"
                    env.DEPLOY_ENV = "${deployEnv}"
                    dir("helm") {
                        sh '$WORKSPACE/dists/jenkins/scripts/deploy-helm.sh'
                    }
                }
            }
        }
    }
}

return this