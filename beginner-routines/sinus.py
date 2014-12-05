#!/usr/bin/env python
# -*- coding: utf-8 -*-
###############################################################################
#                                                                             #
# Sinüs tablosu değer hesaplayıcı                                             #
# wizofwor - Aralık 2014                                                      #
#                                                                             #
# ACME formatında sinüs tablosunu sinus.txt dosyasına kopylar                 #
# Dikkat: Halihazırda var olan dosyayı sinus.txt dosyasını siler!             #
###############################################################################

import math

#Değişkenler
size = 256 		# Değer tablosunun boyutu
maxVal = 64 	# Elde edilecek en büyük değer
minVal = 10		# Elde edilecek en küçük değer

maxLine = int(math.ceil(size/20.0)) #sonucun float olması için bölenin float olması şart! 
line = [None]*(maxLine+3)

#Değerleri hesaplayıp line list'ine yazalım
for i in range (0, maxLine):

	line[i] = "!by "

	for j in range (i*20, i*20+21):
		if j>size:
			break

		x = j*((math.pi*2)/(size-1))
		#x = math.pi / 2	
		sinx = int(math.sin(x)*(maxVal/2-minVal/2+1)+maxVal/2+minVal/2)	
		
		line[i] = line[i] + str(sinx)
		if (j<i*20+20 and j<size):
			line[i] = line[i] + ","

#Comment satırlarını ekleyelim
line.insert(0,";%d'den %d'ye %d değerlik sinus tablosu" % (minVal, maxVal, size))
line.insert(1,";Toplam %d satir" % (maxLine))

#Değerleri dosyaya yazalım:
textFile = open("sinus.txt", "w")
textFile.truncate()
for i in range (0, maxLine+2):
	textFile.write("%s \n" % (line[i]))
textFile.close()

print "%d - %d aralığında, %d byte veri tablosu sinus.pl dosyasına yazıldı." % (maxVal, minVal, size)
