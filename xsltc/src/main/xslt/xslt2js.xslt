<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:include href="expression/expression2js.xslt"/>

    <xsl:include href="util.xslt"/>

    <xsl:include href="xsl/apply-templates2js.xslt"/>
    <xsl:include href="xsl/copy-of2js.xslt"/>
    <xsl:include href="xsl/stylesheet2js.xslt"/>
    <xsl:include href="xsl/template2js.xslt"/>
    <xsl:include href="xsl/value-of2js.xslt"/>

    <xsl:output method="text"/>
    <xsl:preserve-space elements="*"/>

    <xsl:param name="top-level-function-name"/>
    <xsl:param name="tab">&#160;&#160;</xsl:param>
    <xsl:param name="indent-spacing">&#160;&#160;</xsl:param>

    <xsl:template match="xsl:stylesheet">
        <xsl:apply-templates select="." mode="xslt2js"/>
    </xsl:template>

    <xsl:template match="*" mode="xslt2js" priority="0">
        <xsl:param name="indent"/>
        <xsl:param name="resultNode"/>

        <xsl:apply-templates select="." mode="comment">
            <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>
        <xsl:choose>
            <xsl:when test="starts-with(name(.), 'xsl:')">
                <xsl:message>
                    ERROR: <xsl:value-of select="name(.)"/> is not handled! Skipping!
                </xsl:message>
                <xsl:value-of select="$indent"/><xsl:text>// unrecognised XSL element, implementation skipped!</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- add a shallow copy of this node directly -->
                <xsl:variable name="childNode"><xsl:value-of select="$resultNode"/>_1</xsl:variable>

                <!-- var child = copy -->
                <xsl:value-of select="$indent"/>
                <xsl:text>var </xsl:text><xsl:value-of select="$childNode"/><xsl:text> = </xsl:text><xsl:value-of select="$resultNode"/><xsl:text>.createNode("</xsl:text><xsl:value-of select="name(.)"/><xsl:text>");</xsl:text>

                <!-- TODO add in the attributes -->
                <xsl:for-each select="@*">
                    <xsl:value-of select="$indent"/>
                    <xsl:value-of select="$childNode"/><xsl:text>.setAttribute(</xsl:text>
                    <xsl:text>"</xsl:text><xsl:value-of select="name(.)"/>
                    <xsl:text>", </xsl:text>
                    <xsl:choose>
                        <!-- TODO test for this better -->
                        <xsl:when test="contains(., '{') and contains(., '}')">

                            <!-- TODO extract the expression and apply it (we need to trim off those {} brackets) -->
                            <xsl:apply-templates select="." mode="expression2js">
                                <!-- TODO what is the scope of this expression? -->
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>"</xsl:text>
                            <xsl:value-of select="string(.)"/>
                            <xsl:text>"</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>);</xsl:text>
                </xsl:for-each>

                <!-- result.append(child) -->
                <xsl:value-of select="$indent"/>
                <xsl:value-of select="$resultNode"/><xsl:text>.appendNode(</xsl:text><xsl:text></xsl:text><xsl:value-of select="$childNode"/><xsl:text>);</xsl:text>

                <!-- add in the children -->
                <xsl:apply-templates select="*" mode="xslt2js">
                    <xsl:with-param name="indent" select="$indent"/>
                    <xsl:with-param name="resultNode" select="$childNode"/>
                </xsl:apply-templates>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



</xsl:stylesheet>