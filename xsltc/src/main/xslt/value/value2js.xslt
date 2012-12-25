<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">

    <xsl:template match="@*" mode="value2js">
        <xsl:param name="nodeVariableName">node</xsl:param>
        <xsl:param name="valuesVariableName">values</xsl:param>

        <!-- TODO parse -->

        <xsl:variable name="tokens">
            <tokens>
                <xsl:call-template name="value-to-tokens">
                    <xsl:with-param name="value" select="."/>
                </xsl:call-template>
            </tokens>
        </xsl:variable>

        <xsl:apply-templates select="exslt:node-set($tokens)/*" mode="tokens-to-js">
            <xsl:with-param name="nodeVariableName" select="$nodeVariableName"/>
            <xsl:with-param name="resultVariableName" select="$valuesVariableName"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="value-to-tokens">
        <xsl:param name="value"/>

        <xsl:value-of select="$value"/>
    </xsl:template>

    <xsl:template match="text()" mode="tokens-to-js">
        <xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>+</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="expression" mode="tokens-to-js">
        <xsl:param name="nodeVariableName"/>
        <xsl:param name="resultVariableName"/>
        <!-- turn the expression into JavaScript -->
        <xsl:if test="position() = 1">
            <!-- ensure it's a string -->
            <xsl:text>"" + </xsl:text>
        </xsl:if>
        <xsl:call-template name="expression2js">
            <xsl:with-param name="expression" select="."/>
            <xsl:with-param name="nodeVariableName" select="$nodeVariableName"/>
            <xsl:with-param name="valuesVariableName" select="$resultVariableName"/>
        </xsl:call-template>
        <xsl:if test="position() != last()">
            <xsl:text>+</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>