properties(
    [
        buildDiscarder(logRotator(numToKeepStr: '20')),
        parameters(
            [
                string description: 'Enter the username:', name: 'USERNAME'
            ]
        )
    ]
)

pipeline {
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
        stage('Verify') {
            steps {
                sh '''
                    . /home/oracle/scripts/setEnv.sh
                    sqlplus / as sysdba << EOF
                    select account_status from dba_users where USERNAME = upper('${USERNAME}');
                    exit;
                    EOF
                '''
            }
        }
    }
}
