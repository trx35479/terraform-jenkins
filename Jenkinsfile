#!groovy

node {

  def err = null
  def environment = "terraform"
  currentBuild.result = "SUCCESS"
  load "$JENKINS_HOME/.envvars/.env.groovy"

  try {
    stage ('Checkout') {
      checkout scm
    }
    
    stage ('Decrypt the Secrets File') {
      sh """
       ansible-vault decrypt --vault-password-file=${env.VAULT_LOCATION}/${environment}.txt ${environment}.tfvars
       ansible-vault decrypt --vault-password-file=${env.VAULT_LOCATION}/${environment}.txt terraform.tfstate*
       """
    }

    stage ('Terraform Init') {
      print "Init Provider" 
      sh "terraform init"
    }


    stage ('Terraform Validate') {
      print "Validating The TF Files"
      sh "terraform validate -var-file=${environment}.tfvars"
    }
    
    stage ('Terraform Plan') {
      withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'), 
                       string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
        sh """
         set +x
         terraform plan -var-file=${environment}.tfvars -out=create.tfplan 
         """
                       }  
    }

    // wait for approval. If Plan checks out.
    input 'Deploy stack?'
    
    stage ('Terraform Apply') {
      withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'), 
                       string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
        sh """
         set +x
         terraform apply create.tfplan 
         """
       }  
    }
    
    // we should include testing stage(s) here. test-kitchen, infospec, etc... 
    stage ('Re-Encrypt the Secrets File') {
      sh """
       set +x
       ansible-vault encrypt --vault-password-file=${env.VAULT_LOCATION}/${environment}.txt ${environment}.tfvars
       ansible-vault encrypt --vault-password-file=${env.VAULT_LOCATION}/${environment}.txt terraform.tfstate*
       """
    }

    stage ('Push and Merge Terraform State') {
      sh """
        set +x 
        git add terraform.tfstate* *-secrets.tfvars
        git commit -am 'Commit Terraform State - Jenkins Job ${env.JOB_NAME} - build  ${env.BUILD_NUMBER} for ${environment}'
        git push origin HEAD:master
        """

    }

    stage ('Notify') {
      mail from: "email@email.com",
           to: "email@email.com",
           subject: "Terraform Build for ${environment} Complete.",
           body: "Jenkins Job ${env.JOB_NAME} - build  ${env.BUILD_NUMBER} for ${environment}. Please investigate."
    }
  }

  catch (caughtError) {
    err = caughtError
    currentBuild.result = "FAILURE"
  }

  finally {
    /* Must re-throw exception to propagate error */
    if (err) {
      throw err
    }
  }
}
