def build(projs) {
    for (int i = 0; i < projs.size(); i++) {
        def proj = projs.get(i);
        stage("build-maven-${proj}") {
            dir(proj) {
                withDockerContainer(image: 'gradle:5.4.1-jdk8', args: '-v /home/vagrant/.gradle:/home/gradle/.gradle -v /usr/bin/envsubst:/usr/bin/envsubst') {
                    sh 'sh  $WORKSPACE/dists/jenkins/scripts/build-maven.sh'
                    stash(name: 'docker-jar', includes: 'docker/*')
                }
            }
        }
        stage("build-docker-${proj}") {
            dir(proj) {
                unstash 'docker-jar'
                dir("docker") {
                    sh 'sh  $WORKSPACE/dists/jenkins/scripts/build-docker.sh'
                }
            }
        }
        stage("deploy-k8s-${proj}") {
            dir(proj) {
                unstash 'docker-jar'
                dir("docker") {
                    sh 'sh  $WORKSPACE/dists/jenkins/scripts/deploy-k8s.sh'
                }
            }
        }
    }
}

return this