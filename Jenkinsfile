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
                echo 'Switching to blog folder'
                sh 'cd blog'
                echo 'Installing Dependencies'
                sh 'npm install'
				echo 'Building NextJS App'
				sh 'npx next build && npx next export'
            }
        }
        stage('Deployment-Dev') {
            when {
                branch 'feat/*'
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
                        sh "cd infra/blog; terraform init -input=false"
                    }
                }
                stage('Terraform plan') {
                    steps {
                        sh 'cd infra/blog; terraform plan'
                    }
                }
                stage('Terraform apply') {
                    steps {
                        sh 'cd infra/blog; terraform apply'
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