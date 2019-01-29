pipeline {
  agent any
  stages {
    stage('TF Init') {
      steps {
        sh 'terraform init'
      }
    }
    stage('TF Plan') {
      steps {
        sh 'terraform plan -out myplan'
      }
    }
    stage('TF Apply') {
      steps {
        sh 'terraform apply -input=false myplan'
      }
    }
    stage('TF Destroy') {
      steps {
        sh 'terraform destroy -auto-approve'
      }
    }
  }
}
