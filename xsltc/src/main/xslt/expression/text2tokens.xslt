<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="@*" mode="expression-text-to-tokens">
        <token index="{position()}"><xsl:value-of select="."/></token>
    </xsl:template>

</xsl:stylesheet>