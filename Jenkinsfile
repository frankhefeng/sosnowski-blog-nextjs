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
                                export GIT_BRANCH_LOCAL=$(echo ${GIT_BRANCH}   | sed -e "s|origin/||g")
                                export APP_ENV="app-${GIT_BRANCH_LOCAL}"
                                cd infra/blog; 
                                terraform init -input=false
                                terraform workspace select ${APP_ENV} || terraform workspace new ${APP_ENV}
                                terraform plan -var="app_env=${APP_ENV}"
                                terraform apply -var="app_env=${APP_ENV}" -auto-approve
                            '''
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
                            sh '''
                                export GIT_BRANCH_LOCAL=$(echo ${GIT_BRANCH}   | sed -e "s|origin/||g")
                                export APP_ENV="app-${GIT_BRANCH_LOCAL}"
                                cd blog
                                echo 'Installing Dependencies'
                                npm install
                                echo 'Building NextJS App'
                                npx next build && npx next export
                                cd out
                                aws s3 sync . s3://sosnowski-blog-nextjs-965161619314-$APP_ENV
                            '''
                        }
                    }
                }

            }
        }
    }
}