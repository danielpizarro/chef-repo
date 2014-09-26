import argparse, subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--file', default='', help='Define file where is the content to check')
parser.add_argument('--url', help='Define the URL to check', required=True)
parser.add_argument('--max-time', default=10, help='Curl operation time out (seconds) ')
parser.add_argument('--verbose', default=False, help='Verbose curl response ')
parser.add_argument('--header', default='', help='Define header')
parser.add_argument('--user-agent', default='', help='Define User Agent')
args = parser.parse_args()

curl='curl '+ args.url +' -s -m ' + str(args.max_time)
if (args.header!=''):
   curl+= ' -H "' + args.header + '"'
if (args.user_agent!=''):
   curl+= ' -A "' + args.user_agent + '"'

p = subprocess.Popen(curl,shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

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
      print 'curl works but with not the same content'
else:
   for line in p.stdout.readlines():
      print line,
