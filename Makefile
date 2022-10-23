generate:
	tuist fetch
	tuist generate

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	
rm-upstream:
	git remote rm upstream
	
add-upstream:
	git remote add upstream https://github.com/TeamFogFog/FogFog-iOS

dev-sync:
	git fetch upstream
	git merge upstream/develop
	git push
