{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogGroup",
                "logs:PutRetentionPolicy",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
		{
		"Effect": "Allow",
		"Action": "ec2:Describe*",
		"Resource": "*"
		},
		{
		"Effect": "Allow",
		"Action": "elasticloadbalancing:Describe*",
		"Resource": "*"
		},
		{
		"Effect": "Allow",
		"Action": [
			"cloudwatch:ListMetrics",
			"cloudwatch:GetMetricStatistics",
			"cloudwatch:Describe*"
		],
		"Resource": "*"
		},
		{
		"Effect": "Allow",
		"Action": "autoscaling:Describe*",
		"Resource": "*"
		}
    ]
}

sudo yum install git -y
sudo curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh
sudo /opt/td-agent/bin/gem install fluent-plugin-cloudwatch-logs
sudo /opt/td-agent/bin/gem install fluent-plugin-ec2-metadata
sudo rm -R /etc/td-agent/
sudo rm -R /usr/td-agent/
[ ! -d "/usr/td-agent/" ] && sudo mkdir /usr/td-agent/
[ ! -d "/etc/td-agent/" ] && sudo mkdir /etc/td-agent/
[ ! -d "/etc/td-agent/conf.d/" ] && sudo mkdir /etc/td-agent/conf.d/

sudo echo "systemctl stop td-agent;
git clone https://github.com/MarcoMiriade/config-directories /usr/td-agent/install/;
sudo bash /usr/td-agent/install/create_file.sh;
touch /etc/td-agent/td-agent.conf;
lista=(\$(ls /etc/td-agent/conf.d/));
count=\$(ls /etc/td-agent/conf.d/ | wc -l);
for((i=0; i<count; i++))
do
echo \"@include conf.d/\${lista[\$i]}\" >> /etc/td-agent/td-agent.conf;
done
systemctl restart td-agent" > /usr/td-agent/install-dir.sh


sudo echo "systemctl stop td-agent;
sudo rm -R /etc/td-agent/;
touch /etc/td-agent/td-agent.conf;
cd /usr/td-agent/install/;
git pull https://github.com/MarcoMiriade/config-directories;
sudo bash /usr/td-agent/install/create_file.sh;
lista=(\$(ls /etc/td-agent/conf.d/));
count=\$(ls /etc/td-agent/conf.d/ | wc -l);
for((i=0; i<count; i++))
do
  echo \"@include conf.d/\${lista[\$i]}\" >> /etc/td-agent/td-agent.conf
done" > /usr/td-agent/refresh-dir.sh

sudo bash /usr/td-agent/install-dir.sh
sudo bash /usr/td-agent/refresh-dir.sh

sudo systemctl restart td-agent


cat /etc/td-agent/td-agent.conf