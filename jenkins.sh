pipeline {
    parameters {
      string description: 'Enter the username:', name: 'USERNAME'
    }
    agent any

    stages {
        stage('Hello') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                    echo ${USERNAME}
                    . /home/oracle/scripts/setEnv.sh
                    sqlplus / as sysdba << EOF
                    alter user ${USERNAME} account unlock;
                    exit;
                    EOF
                '''
            }
        }
        stage('Text') {
            steps {
                sh 'echo "DONE"'
            }
        }
    }
}
