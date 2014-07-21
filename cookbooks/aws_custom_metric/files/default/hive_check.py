import argparse, subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--file', default='', help='Define file where is the content to check')
parser.add_argument('--command', required=True, help='Define file where is the content to check')
parser.add_argument('--verbose', default=False, help='Verbose ps aux  response ')
args = parser.parse_args()

command='hive -S -e "'+ args.command +'"'
p = subprocess.Popen(command,shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

if (args.file!=''):
   f1 = open (args.file).readlines()
   f2 = p.stdout.readlines()

   for i in range(len(f2)):
      f2[i]=f2[i].strip()
   for i in range(len(f1)):
      f1[i]=f1[i].strip()

   if (f1==f2):
      print 'OK' 
   else:
      print 'Hive service problem'
else:
   for line in p.stdout.readlines():
      print line,
