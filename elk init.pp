[root@puppetmaster manifests]# cat init.pp
class elkzippy
{
if $::osfamily == 'RedHat' {

exec::multi {'java':
             commands => ['yum install -y java','export JAVA_HOME=/usr/java/jdk.1.8.0_60','export PATH=$PATH:$JAVA_HOME','export JRE_HOME=/usr/java/jdk1.8.0_60/jre','export PATH=$PATH:$JRE_HOME/bin','export JAVA_HOME=/usr/java/jdk1.8.0_60','export JAVA_PATH=$JAVA_HOME','export PATH=$PATH:$JAVA_HOME/bin']
}

 exec::multi {'Run':
             commands => ['yum install -y epel-release','yum install -y net-tools','yum install -y wget','rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch','wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.4.rpm','rpm -ivh elasticsearch-6.2.4.rpm'],
}


file { "/etc/elasticsearch/elasticsearch.yml":
      ensure  => 'file',
       mode   => "0644",
       owner  => 'root',
       group  => 'root',
       source => 'puppet:///modules/elkzippy/elasticsearch.yml',
}
file { "/usr/lib/systemd/system/elasticsearch.service":
      ensure  => 'file',
       mode   => "0644",
       owner  => 'root',
       group  => 'root',
       source => 'puppet:///modules/elkzippy/elasticsearch.service',
}
file { "/etc/sysconfig/elasticsearch":
      ensure  => 'file',
       mode   => "0644",
       owner  => 'root',
       group  => 'root',
       source => 'puppet:///modules/elkzippy/elasticsearch',
}
 exec::multi {'system':
             commands => ['systemctl daemon-reload','systemctl enable elasticsearch','systemctl start elasticsearch','wget https://artifacts.elastic.co/downloads/kibana/kibana-6.2.4-x86_64.rpm','rpm -ivh kibana-6.2.4-x86_64.rpm'],
}
file { "/etc/kibana/kibana.yml":
      ensure  => 'file',
       mode   => "0644",
       owner  => 'root',
       group  => 'root',
       source => 'puppet:///modules/elkzippy/kibana.yml',
}
 exec::multi {'kibana':
             commands => ['systemctl enable kibana','systemctl start kibana']
}

 exec::multi {'logstash':
             commands => ['wget https://artifacts.elastic.co/downloads/logstash/logstash-6.2.4.rpm','rpm -ivh logstash-6.2.4.rpm','systemctl enable logstash','systemctl start logstash']

}
}


if $::osfamily == 'Debian' {

exec::multi {'javaRun':
             commands => ['sudo apt install -y openjdk-8-jdk','export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64','echo $JAVA_HOME','export PATH=$PATH:$JAVA_HOME/bin','echo $PATH']
        }


exec::multi {'ubuntuRun':
             commands => ['wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -','echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list','sudo apt -y update','sudo apt install -y elasticsearch']
 }
file { "/etc/elasticsearch/elasticsearch.yml":
      ensure  => 'file',
      mode   => "0644",
      owner  => 'zippyops',
      group  => 'zippyops',
      source => 'puppet:///modules/java/elasticsearch.yml',
}
 exec::multi {'ubuntukibana':
       commands => ['sudo systemctl restart elasticsearch','sudo systemctl enable elasticsearch','sudo apt install -y kibana'],
}
file { "/etc/kibana/kibana.yml":
      ensure  => 'file',
      mode   => "0644",
      owner  => 'zippyops',
      group  => 'zippyops',
      source => 'puppet:///modules/java/kibana.yml',
}
 exec::multi {'kibanadash':
       commands => ['sudo systemctl restart kiban','sudo systemctl enable kibana','sudo apt install -y logstash'],

}
}
if $::osfamily == 'windows' {
 include chocolatey
 $powershell = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NoLogo -NonInteractive'
#exec { 'test1':
#  command => 'powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))',
#}
# remote_file { 'C:\Users\Administrator\Documents\WindowsPowerShell\newinstall.ps1':
#        ensure  => present,
#        source  => 'https://github.com/tamilsaran/windows/blob/master/newinstall.ps1',
#               }
#exec { 'test1':
#  command => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe - file C:\Users\Administrator\Documents\WindowsPowerShell\newinstall.ps1',
#  path    => 'C:/WINDOWS/Sytems32/WindowsPowerShell/v1.0'
#  }

exec { 'test2':
  command => 'choco install -y jdk8',
  path    => $::path
  }
exec { 'test3':
  command => 'choco install -y elasticsearch --version 6.2.4 ',
  path    => $::path
   }
exec { 'test4':
  command => 'choco install -y kibana',
  path    => $::path
   }
exec { 'test5':
  command => 'choco install -y logstash ',
  path    => $::path
   }
# file {'C:\ProgramData\chocolatey\lib\elasticsearch\tools\elasticsearch-6.2.4\config\elasticsearch.yml':
#            ensure => 'absent',
#                }

# remote_file { 'C:\ProgramData\chocolatey\lib\elasticsearch\tools\elasticsearch-6.2.4\config\elasticsearch.yml':
#        ensure  => present,
#        source  => 'https://github.com/tamilsaran/windows/blob/master/elasticsearch.yml',
#               }
#file { 'C:\ProgramData\chocolatey\lib\kibana\tools\kibana-6.2.4-windows-x86_64\config\kibana.yml':
#            ensure => 'absent',
#                }

# remote_file { 'C:\ProgramData\chocolatey\lib\kibana\tools\kibana-6.2.4-windows-x86_64\config\kibana.yml':
#        ensure  => present,
#        source  => 'https://github.com/tamilsaran/windows/blob/master/kibana.yml',
#               }
#exec { 'test6':
#  command => 'C:\ProgramData\chocolatey\lib\elasticsearch\tools\elasticsearch-6.2.4\bin\elasticsearch.bat',

# }
#exec { 'test7':
#  command => 'C:\ProgramData\chocolatey\lib\kibana\tools\kibana-6.2.4-windows-x86_64\bin\kibana.bat',

# }
#exec { 'test8':
#  command => 'C:\ProgramData\chocolatey\lib\logstash\tools\logstash-6.2.4\bin\logstash.bat',

#}
}
}
