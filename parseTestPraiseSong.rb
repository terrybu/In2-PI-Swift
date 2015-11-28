resultsArray = [] 

def parseMessageForNames(str, resultsArray) 
	#first of all, start from the first double linebreak. Get to that index where the double line break starts
	i = 0
	while i < str.length
		if str[i] == "\n"
			if str[i+1] == "\n"
				#found a double linebreak
				j = i + 2 #this is the index at which "1" starts. The first number character of the songs list
				newSongName = "" 
				while str[j] != "\n" 
					newSongName += str[j]
					j+=1
				end
				resultsArray << newSongName
				#this is where we can start the logic after we end the first "songtitle" scraping? because j+1 is now the youtube URL
				k = j + 1
				newYouTubeURL = "" 
				while k < str.length && str[k] != "\n"
					newYouTubeURL += str[k]
					k+=1
				end
				p newYouTubeURL
			end
		end
		i = i+1
	end
end


msgToParse = "[PI찬양] 20151129 주일찬양\n\n1. 세상의 유혹 시험이\nhttps://www.youtube.com/watch?v=arE98TwIwkk\n\n2. 주의 집에 거하는 자\nhttps://youtu.be/vmlinmexeyM?t=21s\n\n3. 호산나 높은 곳에서\nhttps://www.youtube.com/watch?v=7ltD0GK8r3E\n\n4. 내 기쁨 되신주\nhttps://www.youtube.com/watch?v=21RvaWmKIvw"	
parseMessageForNames(msgToParse, resultsArray)
p resultsArray

resultsArray2 = [] 
