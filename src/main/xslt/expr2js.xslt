<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="expr2js">
        <xsl:param name="expr"/>
        <xsl:param name="indent"/>
        <xsl:param name="resultVariableName">result</xsl:param>
        <xsl:param name="nodeVariableName">node</xsl:param>
        <xsl:param name="paramVariableName">params</xsl:param>

        <!--
        <xsl:variable name="line-indent">
            <xsl:call-template name="line-prefix">
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
        </xsl:variable>
        -->

        <xsl:text>var </xsl:text><xsl:value-of select="$resultVariableName"/><xsl:text>;</xsl:text>

    </xsl:template>

</xsl:stylesheet>