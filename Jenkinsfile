pipeline {
	
	agent any
	environment {
		branch = 'master'
		scmUrl = 'https://github.com/frankhefeng/sosnowski-blog-nextjs'
	}	
	
    stages {
        stage('build') {
            steps {
                echo 'Installing Dependencies'
                sh 'npm install'
				echo 'Building NextJS App'
				sh 'node_modules/next/dist/bin/next build'
            }
        }
        stage('deploy development') {
            steps {
                echo 'Deploy Development'
            }
        }
        stage('deploy staging') {
            steps {
                echo 'Deploy Staging'
            }
        }
		stage('deploy production') {
			steps {
				echo 'Deploy Production'
			}
		}
    }
	post {
		failure {
			mail to: 'frankhe.cn@gmail.com', subject: 'Pipeline failed', body: "${env.BUILD_URL}"
		}
	}
}