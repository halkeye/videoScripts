perl -pi -e 's{/media/Drobo01/TV}{/media/Videos/TV}g' /home/halkeye/.xbmc/userdata/sources.xml
perl -pi -e 's{/media/Drobo01/Movies}{/media/Videos/Movies}g' /home/halkeye/.xbmc/userdata/sources.xml
perl -pi -e 's{/media/Drobo02/Anime}{/media/Videos/Anime}g' /home/halkeye/.xbmc/userdata/sources.xml
perl -pi -e 's{/media/Drobo02/Comedian Specials}{/media/Videos/Comedian Specials}g' /home/halkeye/.xbmc/userdata/sources.xml

perl -pi -e 's{/media/Drobo02/Image}{/media/Images/Photos}g' /home/halkeye/.xbmc/userdata/sources.xml
perl -pi -e 's{/media/Drobo02/Comics}{/media/Images/Comics}g' /home/halkeye/.xbmc/userdata/sources.xml

perl -pi -e 's{/media/Drobo02/Audio/Music}{/media/Audio/Music}g' /home/halkeye/.xbmc/userdata/sources.xml

sqlite3 /home/halkeye/.xbmc/userdata/Database/MyVideos34.db "update path set strPath=replace(strPath, '/media/Drobo01/TV', '/media/Videos/TV');"
sqlite3 /home/halkeye/.xbmc/userdata/Database/MyVideos34.db "update path set strPath=replace(strPath, '/media/Drobo01/Movies', '/media/Videos/Movies');"
sqlite3 /home/halkeye/.xbmc/userdata/Database/MyVideos34.db "update path set strPath=replace(strPath, '/media/Drobo02/Anime', '/media/Videos/Anime');"
sqlite3 /home/halkeye/.xbmc/userdata/Database/MyVideos34.db "update path set strPath=replace(strPath, '/media/Drobo02/Comedian Specials', '/media/Videos/Comedian Specials');"

sqlite3 /home/halkeye/.xbmc/userdata/Database/MyVideos34.db "update path set strPath=replace(strPath, '/media/Drobo02/Image', '/media/Images/Photos');"
sqlite3 /home/halkeye/.xbmc/userdata/Database/MyVideos34.db "update path set strPath=replace(strPath, '/media/Drobo02/Comics', '/media/Images/Comics');"

sqlite3 /home/halkeye/.xbmc/userdata/Database/MyMusic7.db "update path set strPath=replace(strPath, '/media/Drobo02/Audio/Music', '/media/Audio/Music');"
