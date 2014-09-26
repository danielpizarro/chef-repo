import argparse, subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--hostname', required=True, help='Define hostname to check and delete')
parser.add_argument('--instance', required=True, help='Define instance to check and delete')
parser.add_argument('--verbose', default=False, help='Verbose')
args = parser.parse_args()

command="/usr/share/CloudWatch/bin/mon-describe-alarms | grep '" + args.hostname +'_' + args.instance +"' | awk '{print $1}' "
p = subprocess.Popen(command,shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

for line in p.stdout.readlines():
    remove = "/usr/share/CloudWatch/bin/mon-delete-alarms --force --alarm-name '"+ line.strip() +"'" 
    r = subprocess.Popen(remove,shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    print line.strip() + ' ' + ' '.join(r.stdout.readlines())
