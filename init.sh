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


sudo curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh
sudo /opt/td-agent/bin/gem install fluent-plugin-cloudwatch-logs
sudo /opt/td-agent/bin/gem install fluent-plugin-ec2-metadata
sudo rm -R /etc/td-agent/
sudo rm -R /var/td-agent/
[ ! -d "/var/td-agent/" ] && sudo mkdir /var/td-agent/
[ ! -d "/etc/td-agent/" ] && sudo mkdir /etc/td-agent/

sudo echo "systemctl stop td-agent;
git clone https://github.com/MarcoMiriade/Create-install-fluentd /var/td-agent/install/;
sudo bash /var/td-agent/install/create_file.sh;
touch /etc/td-agent/td-agent.conf;
lista=(\$(ls /etc/td-agent/));
count=\$(ls /etc/td-agent/ | wc -l);
for((i=0; i<count; i++))
do
echo \"@include \${lista[\$i]}\" >> /etc/td-agent/td-agent.conf;
done
systemctl restart td-agent" > /var/td-agent/install-dir.sh


sudo echo "systemctl stop td-agent;
cd /var/td-agent/install/;
git pull https://github.com/MarcoMiriade/Create-install-fluentd;
sudo bash /var/td-agent/install/create_file.sh;
touch /etc/td-agent/td-agent.conf;
lista=(\$(ls /etc/td-agent/));
count=\$(ls /etc/td-agent/ | wc -l);
for((i=0; i<count; i++))
do
  echo \"@include \${lista[\$i]}\" >> /etc/td-agent/td-agent.conf
done" > /var/td-agent/refresh-dir.sh

sudo bash /var/td-agent/install-dir.sh
sudo bash /var/td-agent/refresh-dir.sh

sudo systemctl restart td-agent


cat /etc/td-agent/td-agent.conf