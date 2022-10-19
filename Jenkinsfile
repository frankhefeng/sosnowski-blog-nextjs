pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                dockerfile {
                    filename 'Dockerfile.build'
                    additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                }
            }
            steps {
                echo 'Installing Dependencies'
                sh 'cd blog; npm install'
				echo 'Building NextJS App'
				sh 'cd blog; npx next build && npx next export'
            }
        }
        stage('Deployment-Dev') {
            when {
                branch 'feat/**'
            }
            agent {
                docker {
                    image 'hashicorp/terraform:light'
                    args '-i --entrypoint='
                }
            }
            stages {
                stage('Terraform init') {
                    steps {
                        withAWS(credentials:'frank') {
                            sh "cd infra/blog; terraform init -input=false"
                        }
                    }
                }
                stage('Terraform plan') {
                    steps {
                        withAWS(credentials:'frank') {
                            sh 'cd infra/blog; terraform plan'
                        }
                    }
                }
                stage('Terraform apply') {
                    steps {
                        withAWS(credentials:'frank') {
                            sh 'cd infra/blog; terraform apply'
                        }
                    }
                }
            }
        }
    }
	// post {
	// 	failure {
	// 		mail to: 'frankhe.cn@gmail.com', subject: 'Pipeline failed', body: "${env.BUILD_URL}"
	// 	}
	// }
}