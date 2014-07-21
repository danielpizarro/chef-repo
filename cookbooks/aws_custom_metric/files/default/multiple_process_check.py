import argparse, subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--file', default='', help='Define file where is the content to check')
parser.add_argument('--process_name', required=True, help='Define process name')
parser.add_argument('--process_id', required=True, help='Define process id')
parser.add_argument('--verbose', default=False, help='Verbose ps aux  response ')
args = parser.parse_args()

command="ps aux | grep -o '"+args.process_name+".*"+args.process_id+"' | fgrep -v '"+args.process_name+".*"+args.process_id+"' | grep -v cron | grep -v .sh | awk '{print $1 \"-\" $3}'"
p = subprocess.Popen(command,shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

if (args.file!=''):
   f1 = open (args.file).readlines()
   f2 = p.stdout.readlines()

   for i in range(len(f2)):
      f2[i]=f2[i].strip()
   for i in range(len(f1)):
      f1[i]=f1[i].strip()

   if (f1[0]==f2[0]):
      print 'OK' 
   else:
      print 'No valid process ('+command+')'
else:
   for line in p.stdout.readlines():
      print line,