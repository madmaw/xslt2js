<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <xsl:value-of select="3+(1+2) * 44 div 3"/>
        <xsl:value-of select="false and true or true and false"/>
    </xsl:template>

    <xsl:template match="a[true=true and false=false]">
        <xsl:value-of select="b['x'='y']/c"/>
    </xsl:template>

</xsl:stylesheet>