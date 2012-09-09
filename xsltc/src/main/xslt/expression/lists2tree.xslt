<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:template match="tokens" mode="expression-lists-to-tree">
        <xsl:apply-templates select="*[0]" mode="expression-lists-to-tree-value"/>
    </xsl:template>

    <xsl:template match="word|variable|string-literal|number-literal" mode="expression-lists-to-tree-value">
        <!-- current value should always be a word, constant, or variable -->
        <!-- look ahead -->
        <xsl:variable name="index" select="@index"/>
        <xsl:variable name="previousTree">
            <xsl:copy-of select="."/>
        </xsl:variable>
        <xsl:apply-templates select="../*[@index=$index+1]" mode="expression-lists-to-tree-operation">
            <xsl:with-param name="previous-tree" select="exslt:node-set($previousTree)"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="open-bracket"  mode="expression-lists-to-tree-value">

    </xsl:template>

    <xsl:template match="child" mode="expression-lists-to-tree-operation">
        <xsl:param name="previous-tree"/>
        <!-- work out the next tree -->
        <xsl:variable name="index" select="@index"/>
        <xsl:variable name="next-tree">
            <xsl:apply-templates select="../*[@index=$index+1]" mode="expression-lists-to-tree-value"/>
        </xsl:variable>

    </xsl:template>

</xsl:stylesheet>