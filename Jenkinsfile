def BLOG_S3_BUCKET_NAME = ""
def BLOG_CLOUDFRONT_DISTRIBUTION_ID = ""
def BLOG_CLOUDFRONT_DOMAIN_NAME = ""

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
                                echo ${BLOG_S3_BUCKET_NAME}
                            '''
                            script {
                                BLOG_S3_BUCKET_NAME = sh(returnStdout: true, script: "terraform output blog_s3_bucket_name").trim()
                                BLOG_CLOUDFRONT_DISTRIBUTION_ID = sh(returnStdout: true, script: "terraform output blog_cloudfront_distribution_id").trim()
                                BLOG_CLOUDFRONT_DOMAIN_NAME = sh(returnStdout: true, script: "terraform output blog_cloudfront_domain_name").trim()
                            }
                            sh "echo ${BLOG_S3_BUCKET_NAME}"
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
                                export GIT_BRANCH_LOCAL=$(echo ${GIT_BRANCH}   | sed -e "s|/|-|g")
                                export APP_ENV="app-${GIT_BRANCH_LOCAL}"
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                                cd out
                                aws s3 sync . s3://${BLOG_S3_BUCKET_NAME}
                                aws cloudfront create-invalidation --distribution-id ${BLOG_CLOUDFRONT_DISTRIBUTION_ID} --paths "/*"
                            '''
                        }
                    }
                }

            }
        }
    }
}