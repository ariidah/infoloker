# debug=True untuk debug
# pastikan sudah membangun server lokal dan rekontruksi (tidak perlu full semua, hanya laman yang diperlukan saja).
# pastikan sudah di isolasi agar tidak menambah traffic ke luar jaringan
# change to https://infoloker.karawangkab.go.id/

import scrapy
import subprocess
debug=False
def grep(filename,string):
    try:
        with open(filename,'r') as obj:
            for line in obj:
                if string in line:
                    obj.close()
                    return True
        return False
    except IOError:
        return False

class infolokerSpider(scrapy.Spider):
    name='infoloker'
    def start_requests(self):
        if not debug:
            urls=['https://infoloker.karawangkab.go.id/',]
        else:
            urls=['http://localhost/',]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        company_name=response.css("div.job-post-item-body a::text").getall()
        location=response.css("div.job-post-item-body span::text").getall()
        jobdesc=response.css("h2.h3::text").getall()
        link=response.css("a.mr-1::attr('href')").getall()

        data=[]
        data.append(company_name)
        data.append(location)
        data.append(jobdesc)
        data.append(link)
        for company_name,location,jobdesc,link in zip(*data):
            print('----------\n'+company_name+' @ '+location+'\nPosisi\t',jobdesc+'\nLink\t',link)
            if not grep('report.txt',link):
                if not debug:
                    with open('report.txt','a') as obj:
                        obj.write('---\n'+jobdesc+'-'+company_name+'@'+location+'\n'+link+'\n')
                        obj.close()
                try:
                    subprocess.Popen(["bash","makecache.sh",link])
                except Exception as e:
                    pass
                try:
                    subprocess.run(["termux-notification","--action","termux-open "+link,"--group","infoloker.karawangkab.go.id","--content",company_name+" @ "+location+"\n"+jobdesc+"\n"+link])
                except Exception as e:
                    print(e,"\nre-check termux-api package")
                    try:
                        subprocess.run(["qrencode","-t","ANSIUTF8",link])
                    except Exception as e:
                        print(e,"\nre-check qrencode package")
                    try:
                        subprocess.run(["notify-send",company_name+" @ "+location+"\n"+jobdesc+"\n"+link])
                    except Exception as e:
                        print(e,"\nre-check notify-send package")
