<xsl:stylesheet
        version="1.1"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exslt="http://exslt.org/common"
        exclude-result-prefixes="exslt">

    <xsl:import href="../util.xslt"/>

    <xsl:param name="word-break-chars">+$/*()[]=,</xsl:param>
    <xsl:param name="number-literal-chars">0123456789</xsl:param>

    <xsl:template match="@*" mode="expression-text-to-tokens">
        <xsl:param name="from">1</xsl:param>
        <xsl:param name="count">1</xsl:param>
        <xsl:param name="previous-was-value" select="false()"/>

        <xsl:variable name="char" select="substring(., $from, 1)"/>
        <xsl:message>
            CHAR[<xsl:value-of select="$from"/>] = <xsl:value-of select="$char"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$from > string-length(.) or $char = ''">
                <!-- we're done -->
            </xsl:when>
            <xsl:when test="normalize-space($char) = ''">
                <!-- skip all white space -->
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                    <xsl:with-param name="previous-was-value" select="$previous-was-value"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '='">
                <equals index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = ','">
                <comma index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '+'">
                <add index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '/'">
                <xsl:variable name="next-char" select="substring(., $from+1, 1)"/>
                <xsl:choose>
                    <xsl:when test="$next-char = '/'">
                        <decendant index="{$count}"/>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="$from + 2"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <child index="{$count}"/>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="$from + 1"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$char = '-'">
                <subtract index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '*'">
                <multiply index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '('">
                <open-bracket index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = ')'">
                <close-bracket index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '['">
                <open-square-bracket index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = ']'">
                <close-square-bracket index="{$count}"/>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="$from + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '$'">
                <xsl:variable name="word">
                    <xsl:apply-templates select="." mode="expression-text-to-tokens-word">
                        <xsl:with-param name="from" select="$from+1"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <variable index="{$count}"><xsl:value-of select="$word"/></variable>
            </xsl:when>
            <xsl:when test="$char = '@'">
                <xsl:variable name="attribute">
                    <xsl:apply-templates select="." mode="expression-text-to-tokens-word">
                        <xsl:with-param name="from" select="$from+1"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="exslt:node-set($attribute)/word/@end + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$char = '&amp;quot;' or $char = &quot;&apos;&quot;">
                <xsl:variable name="element">
                    <xsl:apply-templates select="." mode="expression-text-to-tokens-string-literal">
                        <xsl:with-param name="from" select="$from+1"/>
                        <xsl:with-param name="count" select="$count"/>
                        <xsl:with-param name="end-char" select="$char"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <string-literal index="{$count}"><xsl:value-of select="$element"/></string-literal>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="exslt:node-set($element)/string-literal/@end + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="contains($number-literal-chars, $char)">
                <xsl:variable name="element">
                    <xsl:apply-templates select="." mode="expression-text-to-tokens-number-literal">
                        <xsl:with-param name="from" select="$from"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <number-literal index="{$count}"><xsl:value-of select="$element"/></number-literal>
                <xsl:apply-templates select="." mode="expression-text-to-tokens">
                    <xsl:with-param name="count" select="$count + 1"/>
                    <xsl:with-param name="from" select="exslt:node-set($element)/number-literal/@end"/>
                    <xsl:with-param name="previous-was-value" select="true()"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- pull a string out -->
                <xsl:variable name="word">
                    <xsl:apply-templates select="." mode="expression-text-to-tokens-word">
                        <xsl:with-param name="from" select="$from"/>
                        <xsl:with-param name="count" select="$count"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <xsl:message>
                    WORD: <xsl:copy-of select="$word"/>
                </xsl:message>

                <xsl:choose>
                    <xsl:when test="exslt:node-set($word)/word = 'div' and $previous-was-value">
                        <divide index="{$count}"/>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="exslt:node-set($word)/word/@end + 1"/>
                            <xsl:with-param name="previous-was-value" select="false()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="exslt:node-set($word)/word = 'and' and $previous-was-value">
                        <and index="{$count}"/>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="exslt:node-set($word)/word/@end + 1"/>
                            <xsl:with-param name="previous-was-value" select="false()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="exslt:node-set($word)/word = 'or' and $previous-was-value">
                        <or index="{$count}"/>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="exslt:node-set($word)/word/@end + 1"/>
                            <xsl:with-param name="previous-was-value" select="false()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="exslt:node-set($word)/word = 'true' or exslt:node-set($word)/word = 'false'">
                        <boolean-literal index="{$count}"><xsl:value-of select="exslt:node-set($word)/word"/></boolean-literal>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="exslt:node-set($word)/word/@end + 1"/>
                            <xsl:with-param name="previous-was-value" select="true()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <word index="{$count}"><xsl:value-of select="exslt:node-set($word)/word"/></word>
                        <xsl:apply-templates select="." mode="expression-text-to-tokens">
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="from" select="exslt:node-set($word)/word/@end + 1"/>
                            <xsl:with-param name="previous-was-value" select="true()"/>
                        </xsl:apply-templates>

                    </xsl:otherwise>
                </xsl:choose>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@*" mode="expression-text-to-tokens-string-literal">
        <xsl:param name="from">0</xsl:param>
        <xsl:param name="end-char"/>

        <xsl:variable name="rest" select="substring(.,$from)"/>
        <xsl:variable name="string" select="substring-before($rest, $end-char)"/>

        <xsl:message>end <xsl:value-of select="$from + string-length($string)"/></xsl:message>
        <!-- look up the end point of the token -->
        <string-literal begin="{$from}" end="{$from + string-length($string)}"><xsl:value-of select="$string"/></string-literal>

    </xsl:template>

    <xsl:template match="@*" mode="expression-text-to-tokens-number-literal">
        <xsl:param name="from">1</xsl:param>
        <xsl:param name="to" select="$from"/>

        <xsl:variable name="char" select="substring(.,$to,1)"/>

        <!-- look up the end point of the token -->
        <xsl:choose>
            <xsl:when test="$char != '' and contains($number-literal-chars, $char)">
                <!-- keep going -->
                <xsl:apply-templates select="." mode="expression-text-to-tokens-number-literal">
                    <xsl:with-param name="from" select="$from"/>
                    <xsl:with-param name="to" select="$to + 1"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="number" select="substring(., $from, $to - $from)"/>
                <number-literal begin="{$from}" end="{$to}"><xsl:value-of select="$number"/></number-literal>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="@*" mode="expression-text-to-tokens-word">
        <xsl:param name="from">1</xsl:param>
        <xsl:param name="to" select="$from"/>

        <xsl:variable name="char" select="substring(., $to, 1)"/>
        <xsl:variable name="string" select="substring(., $from, $to+1-$from)"/>
        <xsl:variable name="finishIndex">
            <xsl:choose>
                <xsl:when test="normalize-space($char) = '' or contains($word-break-chars, $char)">
                    <xsl:value-of select="$to - 1"/>
                </xsl:when>
                <xsl:when test="contains($string, '::')">
                    <xsl:value-of select="$to - 2"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- look up the end point of the token -->
        <xsl:message><xsl:value-of select="$from"/>..<xsl:value-of select="$to"/> char '<xsl:value-of select="$char"/>' finished <xsl:value-of select="$finishIndex"/></xsl:message>
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($finishIndex)) > 0">
                <word begin="{$from}" end="{$finishIndex}"><xsl:value-of select="substring(.,$from,$finishIndex+1-$from)"/></word>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="expression-text-to-tokens-word">
                    <xsl:with-param name="from" select="$from"/>
                    <xsl:with-param name="to" select="$to + 1"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>

</xsl:stylesheet>