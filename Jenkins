pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git url: "https://github.com/PoojaNagawade/my-task.git", branch: "main"
            }
            
        }
         stage("build"){
            steps{
                sh "docker build -t mycode ."
            
            }
        }
        stage("deploy"){
            steps{
                sh "docker run -d mycode"
                echo 'deployment ho gayi'
            }
        }
    }
}
