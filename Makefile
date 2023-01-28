
## Help
help:
	@echo 'make help - Выводит команды'
	@echo "make pod - Устанавливает поды"
	@echo "make start - Позволяет быстро открыть workspace проекта"
	@echo "make clean - Очищает содержимое папки DerivedData"

## Устанавливает поды
pod:
	pod install

## Позволяет быстро открыть workspace проекта
start:
	open SpyGameiOS.xcworkspace

## Очищает содержимое папки DerivedData
clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*
