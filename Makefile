#The program name (8 char max)
PROGRAM_NAME = hangman
#The program ext (com or exe, lowercase)
PROGRAM_EXT = com


all: clean program

program:
	./buildenv/build.sh $(PROGRAM_NAME) $(PROGRAM_EXT)

clean:
	rm -f $(PROGRAM_NAME).$(PROGRAM_EXT)
	rm -f $(PROGRAM_NAME).sh

buildenv:
	wget -c "http://download.flogisoft.com/files/various/emu8086/emu8086-buildenv_1.0.tar.gz"
	tar -xzf emu8086-buildenv_1.0.tar.gz
	rm -f emu8086-buildenv_1.0.tar.gz
	cd buildenv/ && ./makeenv.sh

debug:
	mkdir -p ./buildenv/MyBuild/
	rm -f ./buildenv/MyBuild/*
	cp *.asm *.res ./buildenv/MyBuild/
	mv ./buildenv/MyBuild/main.asm ./buildenv/MyBuild/00main.asm
	cat ./buildenv/MyBuild/*.asm ./buildenv/MyBuild/*.res | grep -v include > ./buildenv/MyBuild/_out
	rm ./buildenv/MyBuild/*.asm ./buildenv/MyBuild/*.res
	mv ./buildenv/MyBuild/_out ./buildenv/MyBuild/$(PROGRAM_NAME).asm
	wine ./buildenv/emu8086.exe "" > /dev/null 2> /dev/null
	
