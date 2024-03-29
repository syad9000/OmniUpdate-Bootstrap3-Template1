<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Implementations Skeletor v3 - 5/10/2014

IDENTITY TEMPLATE MATCH
This template ensures that all content is copied, or applied to any existing template matches. Edit sparingly.

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ou="http://omniupdate.com/XSL/Variables"
  xmlns:fn="http://omniupdate.com/XSL/Functions"
  xmlns:ouc="http://omniupdate.com/XSL/Variables"
  exclude-result-prefixes="xs ou fn ouc">
	
    <!-- Identity Matches -->
	
    <!-- The following template matches all items except processing instructions, copies them, then processes any children. -->
    <xsl:template match="attribute()|text()|comment()">
        <xsl:copy />
    </xsl:template>
    
    <xsl:template match="element()">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="attribute()|node()"/>
        </xsl:element>
    </xsl:template>
    	
    <!-- The following template matches processing instructions, outputs the proper syntax with the code escaped properly. -->
	<xsl:template match="php">
		<xsl:if test="$ou:action = 'pub'">
			<xsl:processing-instruction name="php">
					<xsl:value-of select="." disable-output-escaping="yes"/>
			?</xsl:processing-instruction>
		</xsl:if>
		<xsl:if test="$ou:action != 'pub'">
			<p><b>This PHP code will be rendered in browser upon publish.</b></p>
		</xsl:if>
	</xsl:template>
    
    <!-- OUC Matches -->
    
    <!-- OUC Dynamic 3rd Level Tagging -->
    <xsl:template match="ouc:div">
        <xsl:copy>
            <xsl:attribute name="wysiwyg-class"><xsl:value-of select="$bodyClass" /></xsl:attribute>
            <xsl:apply-templates select="attribute()|node()" />
        </xsl:copy>
    </xsl:template>
	
	<xsl:template match="ouc:*[$ou:action !='edt']">
        <xsl:apply-templates />
    </xsl:template>
    
    <!-- MISC -->
    
    <!-- Visual warning for broken dependencies tags -->
    <xsl:template match="a[contains(@href,'*** Broken')]">
        <a href="{@href}" style="color: red;"><xsl:value-of select="."/></a> <span style="color: red;">[BROKEN LINK]</span>
    </xsl:template>
	
	<!--Google Custom Search code-->
    <xsl:template match="gcsesearchbox">
		<xsl:text disable-output-escaping="yes">&lt;gcse:searchbox-only resultsUrl="/search/"&gt;&lt;/gcse:searchbox-only&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="gcsesearchresultsonly">
		<xsl:text disable-output-escaping="yes">&lt;gcse:searchresults-only&gt;&lt;/gcse:searchresults-only&gt;</xsl:text>
	</xsl:template>
	
	
	<!--					-->
	<!--  Custom Elements 	-->
	<!--					-->
	
	<!-- Arrow Tabs Tab Panel -->
	<xsl:template match="table[@class='arrow-tabs-table']">
		<div class="row">
			<div class="col-md-12">
				<div class="arrow-tabs">
					<!-- Nav tabs -->
					<ul class="nav nav-tabs" role="tablist">
						<xsl:for-each select="tbody/tr/th">
							<xsl:variable name="pos" select="position()"/>
							<li role="presentation">
								<xsl:if test="$pos = 1">
									<xsl:attribute name="class"><xsl:text>active</xsl:text></xsl:attribute>
								</xsl:if>
								<a href="#arrow-tab-content{$pos}" aria-controls="arrow-tab-content{$pos}" role="tab" data-toggle="tab"><xsl:copy-of select="node()" /></a>
							</li>
						</xsl:for-each>
					</ul>
					<!-- Tab panes -->
					<div class="tab-content">
						<xsl:for-each select="tbody/tr/td">
							<xsl:variable name="pos" select="position()"/>
							<div role="tabpanel" class="tab-pane" id="arrow-tab-content{$pos}">
								<xsl:if test="$pos = 1">
									<xsl:attribute name="class"><xsl:text>tab-pane active</xsl:text></xsl:attribute>
								</xsl:if>
								<xsl:apply-templates select="node()" />
							</div>
						</xsl:for-each>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<!-- 3x3 Grid table transformation-->
	<xsl:template match="table[@class='threexnine-table']">
		<div class="row">
			<xsl:for-each select="tbody/tr">
				<xsl:for-each select="td">
					<xsl:variable name="section-title">
						<xsl:choose>
							<xsl:when test="ends-with(descendant::a[1]/@href, '_props.html')">
								<xsl:try>
									<xsl:value-of select="doc(concat($ou:root, $ou:site, replace(descendant::a[1]/@href, '.html', '.pcf')))/document/ouc:properties[@label='config']/parameter[@name='breadcrumb']"/>
									<xsl:catch></xsl:catch>
								</xsl:try>
							</xsl:when>
							<xsl:otherwise>
								<xsl:try>
									<xsl:value-of select="descendant::h3"/>
									<xsl:catch></xsl:catch>
								</xsl:try>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- img src value -->
					<xsl:variable name="image-link">
						<xsl:choose>
							<xsl:when test="ends-with(descendant::a[1]/@href, '_props.html')">
								<xsl:try>
									<xsl:value-of select="doc(concat($ou:root, $ou:site, replace(descendant::a[1]/@href, '.html', '.pcf')))/document/ouc:properties[@label='config']/parameter[@name='image']"/>
									<xsl:catch></xsl:catch>
								</xsl:try>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="descendant::img[1]/@src"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- section link value -->
					<xsl:variable name="section-link" 
								  select="if (ends-with(descendant::a[1]/@href, '_props.html')) then substring-before(descendant::a[1]/@href, '_props.html') else descendant::a[1]/@href"/>
					<div class="col-md-4 col-sm-6 col-xs-12">
						<h2> 
							<a href="{$section-link}">
								<xsl:value-of select="$section-title"/>
							</a>
						</h2>
						<div>
							<a href="{$section-link}">
								<xsl:choose>
									<xsl:when test="ends-with(descendant::a[1]/@href, '_props.html')">
										<xsl:try>
											<img src="{$image-link}" class="img-responsive" alt="{$section-title}"/> 
											<xsl:catch></xsl:catch>
										</xsl:try>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="descendant::img"/>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</div>
						<div class="topics-ovpr-bkt" style="padding-bottom:10px">
							<xsl:copy-of select="ul"/>
						</div>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- 3x3 Grid table transformation -->
	<xsl:template match="element()" mode="home-table">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="attribute()|node()"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Accordion Menu transformation -->
	<xsl:template match="table[@class='toggle-table']">
		<div class="toggle-table panel-group panel-primary" id="accordion" role="tablist" aria-multiselectable="true">>
			<xsl:for-each select="tbody/tr">
				<xsl:variable name="pos" select="position()"/>
				<xsl:choose>
					<xsl:when test="descendant::th">
						<xsl:text disable-output-escaping="yes">&lt;div class="panel panel-default"&gt;</xsl:text>
							<div class="panel-heading">
								<h3 class="panel-title">
									<a data-toggle="collapse" data-parent="#accordion" href="#collapse{$pos}"><xsl:copy-of select="node()" /></a>
								</h3>
							</div>
					</xsl:when>
					<xsl:when test="descendant::td">
						<div id="collapse{$pos - 1}" class="panel-collapse collapse {if($pos = 2) then 'in' else ''}">
							<div class="panel-body">
								<xsl:apply-templates select="node()" />
							</div></div>
						<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<!-- Kiffe Accordion Menu -->
	<xsl:template match="table[@class='ouaccordion']">
		<xsl:param name="id" select="position()" />
		
		<div class="toggle-table panel-group panel-primary" id="accordion_{$id}" role="tablist" aria-multiselectable="true">

			<xsl:for-each select="./tbody/tr">
				<xsl:variable name="pos" select="position()" />
				<div class="panel panel-default">
					<div class="panel-heading" role="tab" id="heading_{$id}_{$pos}">
						<h4 class="panel-title">
							<a role="button" data-toggle="collapse" data-parent="#accordion_{$id}" href="#collapse_{$id}_{$pos}" aria-expanded="{if ($pos = 1) then 'true' else 'false'}" aria-controls="collapse_{$id}_{$pos}">
								<xsl:text>ARTICLE </xsl:text>
								<xsl:number format="I"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="td[1]"/>
							</a>
						</h4>
					</div>
					<div id="collapse_{$id}_{$pos}" class="panel-collapse collapse {if ($pos = 1) then 'in' else ''}" role="tabpanel" aria-labelledby="heading_{$id}_{$pos}">
						<div class="panel-body">
							<xsl:apply-templates select="td[2]/node()" />
						</div>
					</div>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="google-static-map">
		<xsl:variable name="url" select="'https://maps.googleapis.com/maps/api/staticmap'"/>
		<xsl:variable name="desc" select="if(@description != '') then @description else 'Google Static Map'"/>
		<xsl:variable name="zoom" select="concat('&amp;zoom=', if(@zoom != '') then @zoom else '14')"/>
		<xsl:variable name="size" select="concat('&amp;size=', if(@size != '') then @size else '450x450')"/>
		<xsl:variable name="api-key" select="if(normalize-space(@api-key) = '') then '' else concat('&amp;key=', @api-key)"/>
				
		<xsl:variable name="center">
			<xsl:choose>
				<!-- given coordinates -->
				<xsl:when test="@center castable as xs:double">
					<xsl:value-of select="concat('?center=', @center)"/>
				</xsl:when>
				<!-- no value given -->
				<xsl:when test="normalize-space(@center) = ''">
					<xsl:value-of select="concat('?center=', '33.94538,-83.37184')"/>
				</xsl:when>
				<!-- given an address -->
				<xsl:otherwise>
					<xsl:value-of select="concat('?center=', encode-for-uri(@center))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="markers">
			<!-- marker="color:red;label:E;latlng:33.94538,-83.37184;size:small" -->
			<xsl:for-each select="@marker">
				<xsl:value-of select="'&amp;markers='"/>
				<xsl:variable name="toks" select="tokenize(., ';')"/>
				<xsl:for-each select="$toks">
					<xsl:variable name="attr" select="tokenize(., ':')"/>
					<xsl:choose>
						<xsl:when test="$attr[1] = 'size'"><xsl:value-of select="concat('size:', $attr[2], '%7C')"/></xsl:when>
						<xsl:when test="$attr[1] = 'color'"><xsl:value-of select="concat('color:', $attr[2], '%7C')"/></xsl:when>
						<xsl:when test="$attr[1] = 'label'"><xsl:value-of select="concat('label:', $attr[2], '%7C')"/></xsl:when>
						<xsl:when test="$attr[1] = 'latlng'"><xsl:value-of select="concat($attr[2], '%7C')"/></xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="marker" select="if($markers != '') then substring($markers, 1, string-length($markers) - 3) else ''"/>
		<!-- Example Path: path=color:0x0000ff|weight:5|40.737102,-73.990318|40.749825,-73.987963|40.752946,-73.987384|40.755823,-73.986397 -->
		<xsl:variable name="path" select="if(normalize-space(@path) != '') then concat('&amp;path=', @path) else ''"/>
		<xsl:choose>
			<xsl:when test="$api-key = ''">
				<div class="bg-danger"><p>NO Google API Key</p></div>
			</xsl:when>
			<xsl:otherwise>
				<img class="google-map img-responsive" src="{concat($url, $center, $marker, $zoom, $size, $path, $api-key)}" alt="{$desc}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="rss-feed">
		<xsl:choose>
			<xsl:when test="$ou:action = 'pub'">
				<!--	
				Require Parameters:
				* rss-feed: a root-relative XML feed to display

				Options
				* tag: String - a OU tag that you want to filter by
				* limit: Integer - number of items to show
				* images: Boolean - show or hide images
				* dates: Boolean - show or hide dates
				* dateFormat: String - PHP Date Format to use (default:'n/j/y')
				* description: Boolean - show or hide description
				* style: String - CSS class to add to the <ul>
				* json: Boolean - Return output as JSON encoded string instead of HTML (default: false)
				* media: Boolean - If true, output will be structured as a Bootstrap Media Object, 
				* 				   otherwise, output is structured as a normal list item.
				-->
				<xsl:processing-instruction name="php">
				require_once($_SERVER['DOCUMENT_ROOT'] . '/_resources/php/wnl.php');
					
				$feed = $_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="@feed"/>";
				$tag = "<xsl:value-of select="@tag"/>";
				$options = [];
				<xsl:for-each select="@*[not(name()='feed') and not(name()='tag')]">
					
					<xsl:text>$options["</xsl:text><xsl:value-of select="name()"/><xsl:text>"] = </xsl:text><xsl:choose>
						<xsl:when test="name() = 'limit'">
							<xsl:value-of select="if(ou:pcfparam('rss-limit') != '') then ou:pcfparam('rss-limit') else '0'" />;
						</xsl:when>
						<xsl:otherwise>
							"<xsl:value-of select="."/>";
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				displayRSS(getRSScategory($feed, $tag), json_encode($options));
				?</xsl:processing-instruction>
			</xsl:when>
			<xsl:otherwise>
				<p style="padding:20px;border:3px black double" class="bg-info">
					<span style="font-size:18px" class="glyphicon glyphicon-list" aria-hidden="true"></span>
					RSS Feed will display on publish.
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
