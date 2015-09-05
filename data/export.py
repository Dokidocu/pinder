# Retrieves tweets from Swiss politicians
# Quick Prototype - pre alpha
# based on tweepy sample file oauth.py

from __future__ import absolute_import, print_function
from time import sleep

import tweepy
import csv
import re

tweettext = dict()
tweetuser = dict()
tweetdate = dict()
taglist = []

# == OAuth Authentication ==
#
# This mode of authentication is the new preferred way
# of authenticating with Twitter.

# The consumer keys can be found on your application's Details
# page located at https://dev.twitter.com/apps (under "OAuth settings")
consumer_key=...
consumer_secret=...

# The access tokens can be found on your applications's Details
# page located at https://dev.twitter.com/apps (located
# under "Your access token")
access_token=...
access_token_secret=...

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.secure = True
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

# If the authentication was successful, you should
# see the name of the account print out
print(api.me().name)

# If the application settings are set for "Read and Write" then
# this line should tweet out the message to your account's
# timeline. The "Read and Write" setting is on https://dev.twitter.com/apps
# api.update_status(status='Updating using OAuth authentication via Tweepy!')
#Export from Twitter

with open('tweets.csv', 'w', encoding='utf8', newline='') as csvfile:
	spamwriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
	# Try to isolate Hashtag - can be done cleaner...
	hashtag = re.compile('#[^ …”!.,;#"@:​!🍎🔗Ė\n\r]+')
	counter =10
	
	# Just one for a quick test
	#for politician in ["FLefortGeneva"]:
	
	# Just the ones from Geneva
	#for politician in ["votrevoix", "CarloSommaruga", "ManuelTornare", "thtanquerel", "Ballymag", "RogerDeneys", "GenderGirl", "RbAudrey", "PLottaz", "gaelle14juillet", "AmelieBargetzi", "thomaswenger", "hhiltpold", "Cluscher", "RolinWavre", "BenoitGenecand", "RobertCramer_GE", "AnneMahrer", "BavarelC", "PierreEckert", "Sophie_ForsterC", "esterhartmannge", "FLefortGeneva", "jeanrossiaud", "LoosliPeter", "magix_ch", "YvesNidegger", "AmaudruzCeline", "leyvrazrosell", "PatrickLussi", "DaveDournow", "xm_etienne", "BarazzoneG", "GuyMettan", "SophieBuchs", "PiccoliAdriano", "pierrebayenet", "AnnickEcuyer", "dsormanni", "SandraBorgeaud", "markkugel", "l_thurnherr", "CharlesPiguet", "LSeydoux", "AlexPeyraud", "joanne_suardi", "valvekabe", "JNUROCK", "m_chappaz", "morand_louise", "Jerome_Jacquier", "VincentDaher", "LaurentNaville", "FabienGrognuz", "EBertinat"]:
	
	# All Swiss romande
	for politician in ["aurel_mascitti", "BLanthemann", "GMarchand_Balet", "roduitbenjamin", "blaise_lovisa", "JR_Fournier", "SalaminJean", "mederiton", "svenrossier", "nmy1986", "MathiasReynard", "gaelbourgeois", "OlivierSalamin", "ThBurgener", "RimaPerruchoud", "frederic_nouchi", "GauthierGlassey", "ValentinAymon", "Gaelribordy", "Pensee_verte", "ClercMat", "J_Savioz", "ced_89", "iris_kndig", "nantermod", "vincentriesen", "avanesiani", "thomas_birbaum", "BlaiseFasel", "PierrePortmann", "Aude012", "kthebti", "ThibautVultier", "AndyGenoud", "Philipona14", "BenjaminEgger2", "FabienPeiry", "LorisGrandjeanD", "AnaisGrandjean", "JeanChardonnens", "RolandMESOT", "ruedischlalfi", "EmanuelWaeber", "Michellosey", "FritzGlauser", "NadineGobet", "SavioMichellod", "YannickGigandet", "JoelMeylan", "GKubski", "simonzurich", "Matthieu_Loup", "MlanieCorreia", "MarchandAntho", "DimMages", "SebastienKolly", "nicole_bardet", "pasquier_n", "messervert", "SylvieBonvin", "KeranKocher", "david_hausmann", "ybuttet", "BinUnited", "david_puippe", "TheophileBalma", "SiggenK", "JollienF", "mcarruzzo", "MayorNoemie", "udcvr64", "IlanGarcia", "GregoryLogean", "NadineReichen", "desmeulesj", "KevPellouchoud", "aida_lips", "SimonBarben", "Mart_INNNN", "anaiscretton", "mariebender", "Jonathandarb", "Maudtheler", "EBertinat", "nabiladresse", "jrdbc", "MatthieuMoser", "virginieheyer", "ValerieOppliger", "CMisiego", "anne_pap", "LSzinho_Rompa", "Savary_Recordon", "FlorentBrandani", "LudoBliesener", "Lcretegny", "NordmannRoger", "ada_marra", "jcschwaab", "CeslaAmarelle", "reb_ruiz", "bendahan", "pdessemontet", "lyonelkaufmann", "Filipuffer", "A_Berthoud", "FloBettschart", "FredericBorloz", "fderder", "FlorenceGross", "AnneGuyaz", "LeubaNicolas", "IsabelleMoret", "LaurentWehrli", "VincentArlettaz", "Ma_Bernhard", "dutruy", "ofantino", "laurineJoCH", "hklunge", "PaolaMhl", "CaroleSchelker", "AebiMichel", "kaltezar", "VictorBraune", "mdelacretaz", "orianeengel", "DeniseGemesio", "Lhautier", "jk_jkuntzmann", "baptistemuller", "QRacine", "Lionel_Voincon", "Savary_Recordon", "adelethorens", "CvanSinger", "TinettaMaystre", "LeonorePorchet", "MauriceMischler", "sevequoz", "mathildechinet", "LRinsoz", "AliceGenoud", "pajaquet", "rebecca_joly", "DaRaedler", "pjueni", "Smishaa", "IliasPanchard", "DanielAnken", "ChloeGut", "AliceGlauser", "pyrapaz", "wernerriesen", "Voiblet", "cedricweissert", "E_Indermuhle", "YohanZiehli", "ArianeVerdan", "NFardel", "petitarthur87", "dylankarlen", "mdrlol85", "CamilleCantone", "franclem2", "samiaDabb", "aurelienhamouti", "CharlottGabriel", "RemiPetitpierre", "RomainPilloudVD", "RaphaelleJavet", "jrilliet", "filipporivola", "Daramsauer", "WaeberJC", "ChristineBussat", "BoschettiSteen", "Mobella7", "StanislasCramer", "carobrennecke", "quentin_krattig", "PAPAMIKE15", "GabrielleBadoux", "malow333", "ClaudeBegle", "NeirynckJ", "GerCret", "axel_marion", "LeManu71", "alainvpoitry", "CBarbezat", "BonaUrs", "I_Chevalley", "ADemaurex", "Mikedupertuis", "lenalio2011", "LaurentMieville", "isfpo", "ClaireRichard56", "B_Vionnet", "Gsaouli", "die_s_man", "Maurice809", "Jealous_nyon", "jonasfornerod", "MeylanFinance", "chevalier70", "Anita_Messere", "Myriam64", "SandrineCornut", "sylvie_villa", "RaneSendrori", "FrBachmann", "RTefik", "SimpleCorrect", "gabriel_klein", "CarlosPoloChois", "votrevoix", "CarloSommaruga", "ManuelTornare", "thtanquerel", "Ballymag", "RogerDeneys", "GenderGirl", "RbAudrey", "PLottaz", "gaelle14juillet", "AmelieBargetzi", "thomaswenger", "hhiltpold", "Cluscher", "RolinWavre", "BenoitGenecand", "RobertCramer_GE", "AnneMahrer", "BavarelC", "PierreEckert", "Sophie_ForsterC", "esterhartmannge", "FLefortGeneva", "jeanrossiaud", "LoosliPeter", "magix_ch", "YvesNidegger", "AmaudruzCeline", "leyvrazrosell", "PatrickLussi", "DaveDournow", "xm_etienne", "BarazzoneG", "GuyMettan", "SophieBuchs", "PiccoliAdriano", "pierrebayenet", "AnnickEcuyer", "dsormanni", "SandraBorgeaud", "markkugel", "l_thurnherr", "CharlesPiguet", "LSeydoux", "AlexPeyraud", "joanne_suardi", "valvekabe", "JNUROCK", "m_chappaz", "morand_louise", "Jerome_Jacquier", "VincentDaher", "LaurentNaville", "FabienGrognuz", "KarineMarti2950", "Gribouille2101", "AnaisGirardin", "FedelePierluigi", "SuzanneMaitre", "Buehler4Bern", "acgraber", "mschnegg", "Shanna_BC", "carojeanq", "AmstutzPierre", "Rationalraetin", "DeGauCHe", "berberatdidier", "MartineDocourt", "MaireJack", "hurnib", "LauraPerret2", "A_deMontmollin", "celinehumbert14", "l_muhlemann", "AurelieWidmer", "ffivaz", "VaraCeline", "patrherrmann", "AndreasJurt", "RaphaelComteCE", "ArlettazMarc", "DamienSchaer", "theoo12", "SoniaBarbosa89", "Michele__Barone", "vonallmenantho", "LeoKienholz", "nicolasjaquet75", "AntGrandjean", "HildMac", "steiertjf", "Valerie_Piller", "uschneiderschue", "david_bonny", "PierreMauron", "ChristianLevrat", "DdeBuman", "BulliardMarbach", "Aebischer_FR", "doutazjp", "Beat_Vonlanthen", "AlbalaBlanche"]:
		# "Ravens_88", "Joanna_Decker", "jessica_n_i", "hasti_h",  had problem - bug in library?
		stati = api.user_timeline(politician)
		print(politician)
		for tweet in stati:
			counter=counter+1
			tweettext[str(counter)]=tweet.text
			tweetuser[str(counter)]=tweet.user.screen_name
			tweetdate[str(counter)]=tweet.created_at
			
			spamwriter.writerow([str(counter), tweet.user.screen_name, tweet.created_at, tweet.text])
			tags=hashtag.findall(tweettext[str(counter)])
			for tag in tags:
				print(tag)
				taglist.append([tag, tweet.user.screen_name, str(counter)])
		sleep(6)
with open('tags.csv', 'w', encoding='utf8', newline='') as tagfile:
	tagwriter = csv.writer(tagfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
	for tag in taglist:
		tagwriter.writerow(tag)
