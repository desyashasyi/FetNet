<?php

namespace App\Support;

class CodeGenerator
{
    // Indonesian + common stop words to skip when building acronym
    private const STOP_WORDS = [
        'dan', 'di', 'ke', 'dari', 'yang', 'dengan', 'untuk', 'dalam',
        'pada', 'oleh', 'atau', 'adalah', 'ini', 'itu', 'the', 'and',
        'of', 'in', 'for', 'to', 'a', 'an',
    ];

    /**
     * Generate a short code from a phrase by taking the first letter
     * of each significant word (skipping stop words).
     *
     * "ELEKTRONIKA DAN KOMPUTER"  → "EK"
     * "TELEKOMUNIKASI"            → "TEL"  (single word fallback)
     * "TEKNIK MESIN PRODUKSI"     → "TMP"
     *
     * @param  string  $phrase
     * @param  int     $maxLen  Maximum length (default 10)
     * @return string  Uppercase code, never empty
     */
    public static function fromPhrase(string $phrase, int $maxLen = 10): string
    {
        $words = preg_split('/[\s\-_\/]+/u', trim($phrase));
        $words = array_filter($words, fn($w) => $w !== '');

        // Filter out stop words; keep original case for fallback but compare lowercase
        $significant = array_values(array_filter(
            $words,
            fn($w) => ! in_array(strtolower($w), self::STOP_WORDS, true)
        ));

        if (empty($significant)) {
            $significant = array_values($words); // all words if everything was a stop word
        }

        // Build acronym from first letter of each significant word
        $acronym = implode('', array_map(fn($w) => mb_strtoupper(mb_substr($w, 0, 1)), $significant));

        // Fallback: if only 1 char (single meaningful word), take first 3 chars of that word
        if (mb_strlen($acronym) === 1) {
            $acronym = mb_strtoupper(mb_substr($significant[0], 0, 3));
        }

        return mb_substr($acronym, 0, $maxLen);
    }
}
