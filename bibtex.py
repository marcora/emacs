from string import *
from Pymacs import lisp
from Bio import PubMed, Medline

## from urllib import urlopen
## from cElementTree import parse, tostring
## import codecs
## from xml.dom.minidom import parse

interactions = {}
    
def pmfetch(pmid):
	""" Fetch and insert a BibTeX reference for PubMed article w/ given PMID at beginning of buffer. """
	try:
		# Init vars
		key = ''
		author = ''
		title = ''
		journal = ''
		year = ''
		volume = ''
		number = ''
		pages = ''
		month = ''
		note = ''
		abstract = ''
		url = ''

		# Format author
		def format_author(author):
			suffix = ''
			if author[-2:] in ('Jr', 'Sr'):
				suffix = author[-2:] + '.'
				author = author[:-3]
			elif author[-3:] in ('2nd', '3rd'):
				suffix = author[-3:]
				author = author[:-4]
			author = split(author, maxsplit=-1)
			last_name = author[0]
			initials = author[1]
			initials = list(initials)
			if suffix:
				initials.append(suffix)
			else:
				initials.append('')
			return strip(last_name + ', ' + '. '.join(initials))

		# Format and check pmid, and fetch article from PubMed
		pmid = str(pmid).strip()
		if not pmid.isdigit(): raise ValueError
		pm = PubMed.Dictionary(parser=Medline.RecordParser())
		article = pm[pmid] # Fetch article from PubMed
		if not article or not article.pubmed_id == pmid: raise ValueError
		if not article.title: raise ValueError
		else: title = article.title
		if not article.no_author and article.authors:
			authors = [format_author(author) for author in article.authors]
			author = ' and '.join(authors)
		if not article.publication_date: raise ValueError
		else: year = article.publication_date[:4]
		if not article.title_abbreviation: raise ValueError
		else: journal = article.title_abbreviation
		if not article.volume_issue: raise ValueError
		else: volume = article.volume_issue
		if not article.pagination: raise ValueError
		else: pages = article.pagination.replace('-','--')
		if article.abstract: abstract = article.abstract
		if article.issue_part_supplement: number = article.issue_part_supplement

		# Create BibTeX ref
		bib = """
@ARTICLE{%s,
   pmid = {%s},
   author = {%s},
   title = {{%s}},
   journal = {%s},
   year = {%s},
   volume = {%s},
   number = {%s},
   pages = {%s},
   month = {%s},
   abstract = {%s},
   note = {%s},
   url = {%s},
}
""" % (key,pmid,author,title,journal,year,volume,number,pages,month,abstract,note,url)

		# Insert BibTeX ref
		lisp.goto_char(lisp.point_min())
		if lisp.re_search_forward(pmid,None,True,1):
			lisp.message('Article with PMID = %s is already in buffer.' % pmid)
			return
		lisp.insert(bib)
		lisp.bibtex_clean_entry()
		lisp.bibtex_fill_entry()
		return
	except:
		lisp.message('Unable to fetch article from PubMed.  Check PMID and try again.')
		return

interactions[pmfetch] = 'sEnter PMID of article to fetch: '

if __name__ == "__main__":
	pmfetch(15242649)#15797719)#15806102)#9858593)

# Local Variables :
# pymacs-auto-reload : t
# End :

##         # PMFetch XML            
##         url = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=PubMed&retmode=xml&rettype=full&id=" + pmid
##         xml = parse(codecs.EncodedFile(urlopen(url), 'utf-8', 'latin-1')).getroot()
##         # print tostring(xml)
##         med = xml.find('.//MedlineCitation')
##         if not med.findtext('PMID') == pmid: raise ValueError

##         # Extract fields from XML article
##         year = med.findtext('./Article/Journal/JournalIssue/PubDate/Year') # check also MedlineDate
##         month = med.findtext('./Article/Journal/JournalIssue/PubDate/Month')
##         title = med.findtext('./Article/ArticleTitle')
##         journal = med.findtext('./MedlineJournalInfo/MedlineTA')
##         volume = med.findtext('./Article/Journal/JournalIssue/Volume')
##         number = med.findtext('./Article/Journal/JournalIssue/Issue')
##         pages = med.findtext('./Article/Pagination/MedlinePgn')
##         abstract = med.findtext('./Article/Abstract/AbstractText')
##         # Extract authors
##         authors = med.findall('./Article/AuthorList/Author')
##         def extractAuthor(author):
##             lastName = author.findtext('./LastName')
##             foreName = author.findtext('./ForeName')
##             suffix = author.findtext('./Suffix')
##             initials = author.findtext('./Initials')
##             collectiveName = author.findtext('./CollectiveName')
##             return "%s, %s." % (lastName, initials)
##         authors = [extractAuthor(author) for author in authors]
##         if med.find('./Article/AuthorList').attrib.get('CompleteYN') == 'N': authors.append('others')
##         author = ' and '.join(authors)

        
##         # AUTHOR and "key"        
## ##         aus = xmldom.getElementsByTagName("Author")
## ##         if aus:
## ##             KEY = aun(aus[0])
## ##             KEY = KEY.replace(" ", "")
## ##             KEY = KEY.replace(",", "")
## ##             KEY = KEY.replace(".", "")
## ##             KEY = KEY + YEAR
## ##             for au in aus:
## ##                 AUTHOR = AUTHOR + aun(au) + " and "
## ##             AUTHOR = AUTHOR[:-5]

## from Tkinter import *
## def hello():
## 	w = Label(None, text="Hello, world!")
## 	w.pack()
## 	w.mainloop()

## interactions[hello] = ''
