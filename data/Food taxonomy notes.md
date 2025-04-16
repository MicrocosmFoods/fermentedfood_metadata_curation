# Running notes on food taxonomy work

# Apr 8, 2025

* Type of ferment \-  
  * Acid  
    * Lactic  
    * Acetic  
  * Alcohol  
  * Degradation  
    * Protein   
    * Fat  
* Processing detail  
  * aerobic/anaerobic  
  * Added ingredients  
    * Salt  
    * Enzymes  
  * Temp  
* Taxonomy proposed by ChatGPT:  
  * TopLevelCategory – high-level grouping (e.g., Dairy-based, Meat-based, Plant-based, Beverage) \# beverage was incorporated into a separate column.  
  * SubstrateCategory – narrower type (e.g., Legume-based, Grain-based, Vegetable-based, etc.)  
  * FoodName – the specific fermented food  
  * RegionOfOrigin (optional) – a known primary region or country of origin (if any)  
  * Notes – anything else (common synonyms, important microbes, or brief clarifications)

# Apr 10, 2025

* Serro cheese is aged at room temp. Aging time and temp is relevant to fermented food but I don’t know if I can find information for many entries.   
* wagashi cheese, like mozzarella, is made without primary fermentation but at high temp.. These cheese may experience some fermentation after its production.   
* Keem is a starter culture used to make Pakhoi. Should we change the metadata?  
* Chicha \- there is use of saliva (the amylase in it). I wrote enzymes to be more clean/scientific in the language. This is the same case with cheese. Should I write protease instead? Renet?   
* I have some thoughts about changing the parameters to give more information. This means creating more columns.   
  * Acid type and acid level  
  * Alcohol \- express in % values instead of yes no. 0 will be instead of no  
  * Split degradation to protein and fat separate and write high/low/moderate/minimal/none  
  * I think that mesophilic, thermophilic or specific temp in special cases (e.g. 70 for a mozz like cheese) is fine.   
* Do we need refs for food info?

# Apr 14, 2025

* Acidity level \- kombucha is high, cheese/yogurt is medium (by default)   
* Cheese info \- I will default to semi-hard cheese (cheddar/swiss) unless I have information  
  * Hard cheese \- high protein, medium fat  
  * Semi hard cheese \- medium protein, low fat  
    * Blue is medium for fat  
    * Brie is high for protein  
  * White cheese \- low protein, no fat  
  * Fat degradation would be lower compared to protein   
  * Main ferment is acid and amino acids for cheeses and acid for white/yogurt  
  * Aging \- yogurt low to no aging. Hard cheese is aged for \>6 months. semi \-hard cheese is aged for \>1 month  
  * Most cheese will have rennet as the added enzyme unless specified differently  
  * By default aging will be cold unless specified otherwise  
  * White-brined cheese (like feta \- cheese that is aged in brine)  
    * High proteolysis, medium lipolysis  
* fermented dairy beverage \- I am making some assumptions here  
  * Most likely it is similar to kefir but I will not include alcohol as a main fermentation product.   
* Alcohol levels \- I am using beer as a reference for medium level, and wine to high level.   
  * 10-15% alcohol is considered the higher level of fermentation which is the common level in wine.   
* Fermented fish \-   
  * Generally the main ferment is amino acids with lactic acid as a more minor ferment. I am also including amines as these are a big contributor to flavor (they are very intense) .   
  * Proteolysis in fermented fish will be high by default (since protein degradation is the main ferment)   
  * I am assuming medium levels of lipolysis unless specified otherwise  
* Aging temp for fermented food will generally be cold. There are a few that are aged in ambient temp and on rare occasions it will be warm aging.   
* There are several instances where I am writing none for all the parameters since ther item is not a food. This includes:  
  * Probiotics \- these are LABs but the product itself is not fermented  
  * kefir grains, Keem \- these are the cultures used to create a fermented food but not the food itself  
  * sour grain mash \- this related to intermediate ingredients and a process in whiskey production. For sour mash I am indicating that there is a medium amount of acid.   
  * Nuruk \- traditional Korean fermentation starter crucial for making various Korean alcoholic beverages like makgeolli (cloudy rice wine), cheongju (clear rice wine), and soju (distilled spirit).     
  * Moromi \- this is a fermentation process or [state](https://japanesetaste.com/blogs/japanese-taste-blog/what-is-moromi-a-unique-process-achieved-through-fermentation?redirected_from=int), not a food product. This is a point at which the ingredients are degraded.  
    * The item we have is a specific moroni so it is a food.   
* Remember to change dawa\_dawa to dawadawa in main dataset  
  * Also dawadawa, soumbala, and iru are the same food   
* Kinema \- there are two variations from soybean and bean paste. They should be the same

# Apr 15, 2025

* Soy sauce \- I decided to write that the aging is hot since it is 30-45C. This is not really ambient  
* fermented soybean meal \- another item that is not really a food item but an ingredient or intermediate. **This is mostly animal feed**  
* tofu chili \- this was essentially a spoiled product that fermented based on the source paper (LeechJ). It was spontaneous fermentation.  
* There are three variations of stinky tofu in the dataset and it should be reduced to one  
* Ugba produces a relatively high amount of butyric acid. I found that interesting since this is a main compound in cheese that is hard to get from plant sources.   
* I searched for generalized information about fermented vegetables. I will use that unless I have a specific food item name.   
* potato kimchi \- I think this is just potatoes with kimchi  
* Dukkah is a spice blend. The LeechJ paper is the source and there it states Dukkah kraut	, and spontaneous fermentation \- i.e. spoilage.   
* Tibicos and kefir water are the same \- I will use the same parameters for both  
* There is an entry about grape cider. I am going to regard it as wine  
* Honey \- it is there but the [source](https://pmc.ncbi.nlm.nih.gov/articles/PMC5454198/) is not fermented as far as I can tell  
* fermented cane molasses at alcohol plants \- this is a by product or intermediate and not a food product