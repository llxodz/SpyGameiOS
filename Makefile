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
