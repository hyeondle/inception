<?php
define('DB_NAME', getenv('WP_DB_NAME'));
define('DB_USER', getenv('WP_DB_USER'));
define('DB_PASSWORD', getenv('WP_DB_PASSWORD'));
define('DB_HOST', getenv('WP_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
// 보안 키 설정
define('AUTH_KEY',         'HZ_s1Y:@OTMVj%SL lCaX|8  a7I#Ua-(OT2Z9t$1Y@jF!qDpdpMxsPaCei`JL@k');
define('SECURE_AUTH_KEY',  'P#wxT`SlF#peV;fu+q=H^@[j7L_?DxP0&}+.!kBxB:vjb3`Dk7B|}Yx1K`(rfkjB');
define('LOGGED_IN_KEY',    'Q5WNWf=:zURM<-fF5sKMdSZzczkn~.P^wzm Wq|.X2BumO.#q KFN/caZPV}?+Tk');
define('NONCE_KEY',        ':0h>;T6YZzFReOyz[aE2vPqtcF6|9h}+-D{jTm5rmxK_q^3Qu*<-GF7:Y<*&toCL');
define('AUTH_SALT',        'XK&RN(xrpCe57SPWV<&TE7OcOV?J &+4b?HR3&b0zn,tnx:fH:PMsi!-baW4 DV)');
define('SECURE_AUTH_SALT', '-n2bzB3oi>[0jA7sd8p<+8>kg1NFP^e>Ib- A$[l+x[%zv|r3`DuE~M()PZ1%DZc');
define('LOGGED_IN_SALT',   'L#cB/Jhld]j9|:Ri+>*-9G% H^OCnUEQ;qJxU|kUF-UtXzzH$<lYp:ih1,LJ#^me');
define('NONCE_SALT',       '9L+nUwq=nTf|||Jm%N|goP#e%b[X&2_m9C4^ez<*KpXE jmt2zvSin4|ppB`~}--');

// 테이블 접두사
$table_prefix = 'wp_';

// 개발자들을 위한 디버깅 모드
define('WP_DEBUG', false);

/* 아래 내용은 수정하면 안 됩니다. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');