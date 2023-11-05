
## Help
help:
	@echo "Основные:"
	@echo "\tmake gen - генерация проекта и установка зависимостей"
	@echo "\tmake start - Позволяет быстро открыть workspace проекта"
	@echo "Дополнительные:"
	@echo "\tmake pod - Устанавливает поды"
	@echo "\tmake clean - Очищает содержимое папки DerivedData"

## Генерация проекта
gen:
	xcodegen
	pod install

## Устанавливает поды
pod:
	pod install

## Позволяет быстро открыть workspace проекта
start:
	open SpyGameiOS.xcworkspace

## Очищает содержимое папки DerivedData
clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*
