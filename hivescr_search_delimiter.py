#!/usr/bin/python

import sys

# hivescr_search_delimiter v1.0
 
# contoh penggunaan :
# $ python hivescr_search_delimiter.py "xx;xxx,xx;xxxx;xxx,xx" "yyyy,yyyy;yy;yy,yy" ""

# --------------------------------------------------------------------------------
# Mencari 2 string delimiter dengan menggunakan frekuensi tertinggi
# --------------------------------------------------------------------------------
def searchDelimiterWithHighestAndSameFrequency(string1, string2):
	delimiter = "NO_DELIMITER"
	knownDelimiters = [",", "\t", ";", "|", " "];
	n0 = 1
	for d in knownDelimiters:
		n1 = len(string1.split(d))
		n2 = len(string2.split(d))
		if ((n1 == n2) & (n1 > n0)):
			delimiter = d
			n0 = n1
	return delimiter;
# --------------------------------------------------------------------------------
# 
# --------------------------------------------------------------------------------
# Mengubah content dari substring jika ada quote karakter 
# --------------------------------------------------------------------------------
def transformSubstringsSurroundedByQuoteChar(aString, aChar):
	outputString = ""
	joker = "Z"
	writeJoker = False
	if (aString[0] == aChar):
		writeJoker = True
	for s in aString:
		if (writeJoker == False) & (s == aChar):
			writeJoker = True
		elif (writeJoker == True) & (s == aChar):
			writeJoker = False
			s = joker
		if (writeJoker == True):
			outputString += joker
		else:
			outputString += s
	return outputString;
# --------------------------------------------------------------------------------

string1 = sys.argv[1]
string2 = sys.argv[2]
quotechar = sys.argv[3]

if quotechar:
	string1 = transformSubstringsSurroundedByQuoteChar(string1, quotechar)
	string2 = transformSubstringsSurroundedByQuoteChar(string2, quotechar)

delimiter = searchDelimiterWithHighestAndSameFrequency(string1, string2)
if delimiter == "\t":
	delimiter = "\\t"
if delimiter == " ":
        delimiter = "\\s"

print delimiter