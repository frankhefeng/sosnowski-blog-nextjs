def BLOG_S3_BUCKET_NAME = ""
def BLOG_CLOUDFRONT_DISTRIBUTION_ID = ""
def BLOG_CLOUDFRONT_DOMAIN_NAME = ""

def getRepoURL() {
  sh "git config --get remote.origin.url > .git/remote-url"
  return readFile(".git/remote-url").trim()
}

void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: getRepoURL()],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

pipeline {
    agent none
    stages {
        stage('dev') {
            when { branch 'feat/**' }
            stages {
                stage('Infra') {
                    agent {
                        docker {
                            image 'hashicorp/terraform:light'
                            args '-i --entrypoint='
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                export GIT_BRANCH_LOCAL=$(echo ${GIT_BRANCH}   | sed -e "s|/|-|g")
                                export APP_ENV="app-${GIT_BRANCH_LOCAL}"
                                cd infra/blog; 
                                terraform init -input=false
                                terraform workspace select ${APP_ENV} || terraform workspace new ${APP_ENV}
                                terraform plan -var="app_env=${APP_ENV}"
                                terraform apply -var="app_env=${APP_ENV}" -auto-approve
                            '''
                            script {
                                BLOG_S3_BUCKET_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_s3_bucket_name").trim()
                                BLOG_CLOUDFRONT_DISTRIBUTION_ID = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_distribution_id").trim()
                                BLOG_CLOUDFRONT_DOMAIN_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_domain_name").trim()
                            }
                        }
                    }
                }
                stage('Website') {
                    agent {
                        dockerfile {
                            filename 'Dockerfile.build'
                            additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh "echo ${BLOG_S3_BUCKET_NAME}"
                            sh '''
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                            '''
                            sh "cd blog/out; aws s3 sync . s3://${BLOG_S3_BUCKET_NAME}"
                            sh "aws cloudfront create-invalidation --distribution-id $BLOG_CLOUDFRONT_DISTRIBUTION_ID --paths '/*'"
                        }
                    }
                }
            }
        }
        stage('pull-request') {
            when { changeRequest() }
            stages {
                stage('Infra') {
                    agent {
                        docker {
                            image 'hashicorp/terraform:light'
                            args '-i --entrypoint='
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                export APP_ENV="app-${BRANCH_NAME}"
                                cd infra/blog; 
                                terraform init -input=false
                                terraform workspace select ${APP_ENV} || terraform workspace new ${APP_ENV}
                                terraform plan -var="app_env=${APP_ENV}"
                                terraform apply -var="app_env=${APP_ENV}" -auto-approve
                            '''
                            script {
                                BLOG_S3_BUCKET_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_s3_bucket_name").trim()
                                BLOG_CLOUDFRONT_DISTRIBUTION_ID = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_distribution_id").trim()
                                BLOG_CLOUDFRONT_DOMAIN_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_domain_name").trim()
                            }
                        }
                    }
                }
                stage('Website') {
                    agent {
                        dockerfile {
                            filename 'Dockerfile.build'
                            additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh "echo ${BLOG_S3_BUCKET_NAME}"
                            sh '''
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                            '''
                            sh "cd blog/out; aws s3 sync . s3://${BLOG_S3_BUCKET_NAME}"
                            sh "aws cloudfront create-invalidation --distribution-id $BLOG_CLOUDFRONT_DISTRIBUTION_ID --paths '/*'"
                        }
                    }
                }
            }
        }
        stage('test') {
            when { branch 'test' }
            stages {
                stage('Infra') {
                    agent {
                        docker {
                            image 'hashicorp/terraform:light'
                            args '-i --entrypoint='
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                export APP_ENV="app-test"
                                cd infra/blog; 
                                terraform init -input=false
                                terraform workspace select ${APP_ENV} || terraform workspace new ${APP_ENV}
                                terraform plan -var="app_env=${APP_ENV}"
                                terraform apply -var="app_env=${APP_ENV}" -auto-approve
                            '''
                            script {
                                BLOG_S3_BUCKET_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_s3_bucket_name").trim()
                                BLOG_CLOUDFRONT_DISTRIBUTION_ID = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_distribution_id").trim()
                                BLOG_CLOUDFRONT_DOMAIN_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_domain_name").trim()
                            }
                        }
                    }
                }
                stage('Website') {
                    agent {
                        dockerfile {
                            filename 'Dockerfile.build'
                            additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh "echo ${BLOG_S3_BUCKET_NAME}"
                            sh '''
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                            '''
                            sh "cd blog/out; aws s3 sync . s3://${BLOG_S3_BUCKET_NAME}"
                            sh "aws cloudfront create-invalidation --distribution-id $BLOG_CLOUDFRONT_DISTRIBUTION_ID --paths '/*'"
                        }
                    }
                }
            }
        }
        stage('prod') {
            when { branch 'master'}
            stages {
                stage('Infra') {
                    agent {
                        docker {
                            image 'hashicorp/terraform:light'
                            args '-i --entrypoint='
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh '''
                                export APP_ENV="app-prod"
                                cd infra/blog; 
                                terraform init -input=false
                                terraform workspace select ${APP_ENV} || terraform workspace new ${APP_ENV}
                                terraform plan -var="app_env=${APP_ENV}"
                                terraform apply -var="app_env=${APP_ENV}" -auto-approve
                            '''
                            script {
                                BLOG_S3_BUCKET_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_s3_bucket_name").trim()
                                BLOG_CLOUDFRONT_DISTRIBUTION_ID = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_distribution_id").trim()
                                BLOG_CLOUDFRONT_DOMAIN_NAME = sh(returnStdout: true, script: "cd infra/blog; terraform output blog_cloudfront_domain_name").trim()
                            }
                        }
                    }
                }
                stage('Website') {
                    agent {
                        dockerfile {
                            filename 'Dockerfile.build'
                            additionalBuildArgs '--build-arg UID=$(id -u) --build-arg GID=$(id -g)  --build-arg UNAME=jenkins'
                        }
                    }
                    steps {
                        withAWS(credentials:'blog') {
                            sh "echo ${BLOG_S3_BUCKET_NAME}"
                            sh '''
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                            '''
                            sh "cd blog/out; aws s3 sync . s3://${BLOG_S3_BUCKET_NAME}"
                            sh "aws cloudfront create-invalidation --distribution-id $BLOG_CLOUDFRONT_DISTRIBUTION_ID --paths '/*'"
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            setBuildStatus("Build succeeded. Preview URL: https://${BLOG_CLOUDFRONT_DOMAIN_NAME}", "SUCCESS");
        }
        failure {
            setBuildStatus("Build failed", "FAILURE");
        }
    }
}