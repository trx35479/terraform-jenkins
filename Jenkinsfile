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
        sh """
         set +x
         terraform plan -var-file=${environment}.tfvars -out=create.tfplan 
         """
      }  
    }

    // wait for approval. If Plan checks out.
    input 'Deploy stack?'
    
    stage ('Terraform Apply') {
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

    stage ('Notify') {
      mail from: "rowel.uchi@unico.com.au",
           to: "rowel.uchi@unico.com.au",
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
