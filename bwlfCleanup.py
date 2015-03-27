###############
# B(eo)W(u)LF Code:
# By-Word Long-Form Data Preparation

# This code reads in a sample text file, reformats it, and exports it to
# a new file before further formatting and analysis.

# Written by: 
# Date last modified: June 16, 2013
###############

# coding:utf-8
import os,re,unicodedata,shlex,glob

# read in text file
os.chdir('~/bwlfTechReport/')
beowulfText = open('beowulfTextSnippet.txt','r') # open file
beowulf = beowulfText.read() # read in text

# start the cleanup (change according to text)
beowulf = re.sub('\r','\n',beowulf) # ensure all newlines are identical
beowulf = re.sub('(^|\n)([A-Z]{2,}( |,))','\n\n[canto]\n\\2',beowulf) # create canto indicator
beowulf = re.sub(':|;|(\-)|,',' ',beowulf) # remove non-target punctuation
beowulf = re.sub('(\.){3,}','.',beowulf)
beowulf = re.sub(' {1,}',' ',beowulf) # remove redundant spaces

# convert all text to lower case
beowulf = beowulf.lower()

# split by spaces
beowulf = re.sub('\n(?=([A-Z]|[a-z]|\"))',' [line] ',beowulf) # create line indicator
beowulf = re.sub('\n',' ',beowulf) # change newline to space
beowulf = re.split(' +',beowulf) # split file by space
beowulf = str(beowulf) # convert to a string
beowulf = re.sub('((\')|("))\, ((\')|("))',',',beowulf) # remove extraneous quotations
beowulf = re.sub('\,{2}',',',beowulf) # remove empty cells
beowulf = re.sub('(\[\'(,)?)|(\'\])','',beowulf) # remove extraneous brackets

# close file and print new file
beowulfText.close()
cleaned = file('beowulfCleaned.csv','w')
cleaned.write(beowulf)
cleaned.close()