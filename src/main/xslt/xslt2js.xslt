<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text"/>

    <xsl:preserve-space elements="*"/>

    <xsl:include href="expr2js.xslt"/>

    <xsl:param name="top-level-function-name"/>
    <xsl:param name="indent-spacing">&#160;&#160;</xsl:param>

    <xsl:template match="xsl:stylesheet">
        <xsl:param name="indent">0</xsl:param>

        <xsl:variable name="line-indent">
            <xsl:call-template name="line-prefix">
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:apply-templates select="." mode="comment-element">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <!-- assume we have a stylesheet element -->
        <xsl:value-of select="$line-indent"/>
        <xsl:if test="$top-level-function-name">
            <xsl:value-of select="$top-level-function-name"/><xsl:text> = </xsl:text>
        </xsl:if>
        <xsl:text>(function(resultDOM, node, params) {</xsl:text>
        <xsl:apply-templates select="*">
            <xsl:with-param name="indent" select="$indent + 1"/>
        </xsl:apply-templates>
        <xsl:value-of select="$line-indent"/><xsl:text>})();</xsl:text>
    </xsl:template>

    <xsl:template match="xsl:copy-of">
        <xsl:param name="indent"/>

        <xsl:variable name="line-indent">
            <xsl:call-template name="line-prefix">
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:apply-templates select="." mode="comment-element">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>

        <xsl:value-of select="$line-indent"/><xsl:text>{</xsl:text>
        <xsl:call-template name="expr2js">
            <xsl:with-param name="expr" select="@select"/>
            <xsl:with-param name="indent" select="$indent + 1"/>
        </xsl:call-template>
        <xsl:value-of select="$line-indent"/><xsl:text>resultDOM.append(result);</xsl:text>
        <xsl:value-of select="$line-indent"/><xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="*" mode="comment-element">
        <xsl:param name="indent"/>

        <xsl:variable name="line-indent">
            <xsl:call-template name="line-prefix">
                <xsl:with-param name="indent" select="$indent"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$line-indent"/><xsl:text>// &lt;</xsl:text><xsl:value-of select="name(.)"/><xsl:text>&gt;</xsl:text>
    </xsl:template>



    <xsl:template name="line-prefix">
        <xsl:param name="indent"/>
        <xsl:text>
</xsl:text>
        <xsl:call-template name="line-prefix-space">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="line-prefix-space">
        <xsl:param name="indent"/>
        <xsl:if test="$indent > 0">
            <xsl:value-of select="$indent-spacing"/>
            <xsl:call-template name="line-prefix-space">
                <xsl:with-param name="indent" select="$indent - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>