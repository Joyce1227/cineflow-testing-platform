-- CineFlow 豆瓣 Top 200 电影导入文件
-- 抓取时间（UTC）：2026-10-01T06:39:17.621103+00:00
-- 来源：https://movie.douban.com/top250（仅取公开榜单前200条）
-- 说明：榜单未提供的语言、上映日期、片长和完整剧情保持 NULL。
-- 幂等策略：先按片名+年份关联已有演示数据，再按 douban_id 更新或插入。
SET NAMES utf8mb4;
START TRANSACTION;

-- Top 1: 肖申克的救赎
UPDATE movie SET douban_id='1292052', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='肖申克的救赎' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292052', '肖申克的救赎', 'The Shawshank Redemption / 月黑高飞(港) / 刺激1995(台)', '蒂姆·罗宾斯 Tim Robbins /...', '弗兰克·德拉邦特 Frank Darabont', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2934829882.jpg', '犯罪/剧情', '美国', NULL, 1994, NULL, NULL, NULL, 9.70, 3346336, 3346336, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 2: 霸王别姬
UPDATE movie SET douban_id='1291546', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='霸王别姬' AND release_year = 1993 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291546', '霸王别姬', '再见，我的妾 / Farewell My Concubine', '张国荣 Leslie Cheung / 张丰毅 Fengyi Zha...', '陈凯歌 Kaige Chen', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2911205318.jpg', '剧情/爱情/同性', '中国大陆/中国香港', NULL, 1993, NULL, NULL, NULL, 9.60, 2456705, 2456705, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 3: 泰坦尼克号
UPDATE movie SET douban_id='1292722', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='泰坦尼克号' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292722', '泰坦尼克号', 'Titanic / 铁达尼号(港 / 台)', '莱昂纳多·迪卡普里奥 Leonardo...', '詹姆斯·卡梅隆 James Cameron', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p457760035.jpg', '剧情/爱情/灾难', '美国', NULL, 1997, NULL, NULL, NULL, 9.50, 2534028, 2534028, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 4: 阿甘正传
UPDATE movie SET douban_id='1292720', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='阿甘正传' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292720', '阿甘正传', 'Forrest Gump / 福雷斯特·冈普', '汤姆·汉克斯 Tom Hanks / ...', '罗伯特·泽米吉斯 Robert Zemeckis', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p510876253.jpg', '剧情/爱情', '美国', NULL, 1994, NULL, NULL, NULL, 9.50, 2460909, 2460909, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 5: 千与千寻
UPDATE movie SET douban_id='1291561', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='千与千寻' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291561', '千与千寻', '千と千尋の神隠し / 神隐少女(台) / 千与千寻的神隐', '柊瑠美 Rumi Hîragi / 入野自由 Miy...', '宫崎骏 Hayao Miyazaki', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2557573348.jpg', '剧情/动画/奇幻', '日本', NULL, 2001, NULL, NULL, NULL, 9.40, 2573007, 2573007, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 6: 星际穿越
UPDATE movie SET douban_id='1889243', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='星际穿越' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1889243', '星际穿越', 'Interstellar / 星际启示录(港) / 星际效应(台)', '马修·麦康纳 Matthew Mc...', '克里斯托弗·诺兰 Christopher Nolan', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2614988097.jpg', '剧情/科幻/冒险', '美国/英国/加拿大', NULL, 2014, NULL, NULL, NULL, 9.40, 2229964, 2229964, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 7: 美丽人生
UPDATE movie SET douban_id='1292063', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='美丽人生' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292063', '美丽人生', 'La vita è bella / 一个快乐的传说(港) / Life Is Beautiful', '罗伯托·贝尼尼 Roberto Beni...', '罗伯托·贝尼尼 Roberto Benigni', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2578474613.jpg', '剧情/喜剧/爱情/战争', '意大利', NULL, 1997, NULL, NULL, NULL, 9.50, 1500673, 1500673, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 8: 这个杀手不太冷
UPDATE movie SET douban_id='1295644', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='这个杀手不太冷' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1295644', '这个杀手不太冷', 'Léon / 终极追杀令(台) / 杀手莱昂', '让·雷诺 Jean Reno / 娜塔莉·波特曼 ...', '吕克·贝松 Luc Besson', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2913554676.jpg', '剧情/动作/犯罪', '法国/美国', NULL, 1994, NULL, NULL, NULL, 9.40, 2580002, 2580002, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 9: 盗梦空间
UPDATE movie SET douban_id='3541415', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='盗梦空间' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3541415', '盗梦空间', 'Inception / 潜行凶间(港) / 全面启动(台)', '莱昂纳多·迪卡普里奥 Le...', '克里斯托弗·诺兰 Christopher Nolan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p513344864.jpg', '剧情/科幻/悬疑/冒险', '美国/英国', NULL, 2010, NULL, NULL, NULL, 9.40, 2360486, 2360486, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 10: 楚门的世界
UPDATE movie SET douban_id='1292064', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='楚门的世界' AND release_year = 1998 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292064', '楚门的世界', 'The Truman Show / 真人Show(港) / 真人戏', '金·凯瑞 Jim Carrey / 劳拉·琳妮 Lau...', '彼得·威尔 Peter Weir', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p479682972.jpg', '剧情/科幻', '美国', NULL, 1998, NULL, NULL, NULL, 9.40, 2054118, 2054118, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 11: 辛德勒的名单
UPDATE movie SET douban_id='1295124', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='辛德勒的名单' AND release_year = 1993 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1295124', '辛德勒的名单', 'Schindler''s List / 舒特拉的名单(港) / 辛德勒名单', '连姆·尼森 Liam Neeson...', '史蒂文·斯皮尔伯格 Steven Spielberg', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p492406163.jpg', '剧情/历史/战争', '美国', NULL, 1993, NULL, NULL, NULL, 9.50, 1262247, 1262247, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 12: 忠犬八公的故事
UPDATE movie SET douban_id='3011091', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='忠犬八公的故事' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3011091', '忠犬八公的故事', 'Hachi: A Dog''s Tale / 秋田犬八千(港) / 忠犬小八(台)', '理查·基尔 Richard Ger...', '莱塞·霍尔斯道姆 Lasse Hallström', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2587099240.jpg', '剧情', '美国/英国', NULL, 2009, NULL, NULL, NULL, 9.40, 1560688, 1560688, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 13: 海上钢琴师
UPDATE movie SET douban_id='1292001', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='海上钢琴师' AND release_year = 1998 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292001', '海上钢琴师', 'La leggenda del pianista sull''oceano / 声光伴我飞(港) / 一九零零的传奇', '蒂姆·罗斯 Tim Roth / ...', '朱塞佩·托纳多雷 Giuseppe Tornatore', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2914698334.jpg', '剧情/音乐', '意大利', NULL, 1998, NULL, NULL, NULL, 9.30, 1902529, 1902529, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 14: 疯狂动物城
UPDATE movie SET douban_id='25662329', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='疯狂动物城' AND release_year = 2016 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25662329', '疯狂动物城', 'Zootopia / 优兽大都会(港) / 动物方城市(台)', '金妮弗·...', '拜伦·霍华德 Byron Howard / 瑞奇·摩尔 Rich Moore', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2924128964.jpg', '喜剧/动画/冒险', '美国', NULL, 2016, NULL, NULL, NULL, 9.30, 2360086, 2360086, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 15: 三傻大闹宝莱坞
UPDATE movie SET douban_id='3793023', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='三傻大闹宝莱坞' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3793023', '三傻大闹宝莱坞', '3 Idiots / 三个傻瓜(台) / 作死不离3兄弟(港)', '阿米尔·汗 Aamir Khan / 卡...', '拉库马·希拉尼 Rajkumar Hirani', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p579729551.jpg', '剧情/喜剧/爱情/歌舞', '印度', NULL, 2009, NULL, NULL, NULL, 9.20, 2104735, 2104735, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 16: 机器人总动员
UPDATE movie SET douban_id='2131459', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='机器人总动员' AND release_year = 2008 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '2131459', '机器人总动员', 'WALL·E / 太空奇兵·威E(港) / 瓦力(台)', '本·贝尔特 Ben Burtt / 艾丽...', '安德鲁·斯坦顿 Andrew Stanton', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2934742160.jpg', '科幻/动画/冒险', '美国', NULL, 2008, NULL, NULL, NULL, 9.30, 1526122, 1526122, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 17: 放牛班的春天
UPDATE movie SET douban_id='1291549', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='放牛班的春天' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291549', '放牛班的春天', 'Les choristes / 歌声伴我心(港) / 唱诗班男孩', '让-巴蒂斯特·莫尼...', '克里斯托夫·巴拉蒂 Christophe Barratier', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2884280708.jpg', '剧情/音乐', '法国/瑞士/德国', NULL, 2004, NULL, NULL, NULL, 9.30, 1493040, 1493040, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 18: 无间道
UPDATE movie SET douban_id='1307914', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='无间道' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1307914', '无间道', '無間道 / Infernal Affairs / Mou gaan dou', '刘德华 Andy Lau / 梁朝伟 Tony Leung Chiu W...', '刘伟强 / 麦兆辉', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2597979873.jpg', '剧情/犯罪/惊悚', '中国香港', NULL, 2002, NULL, NULL, NULL, 9.30, 1589288, 1589288, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 19: 控方证人
UPDATE movie SET douban_id='1296141', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='控方证人' AND release_year = 1957 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1296141', '控方证人', 'Witness for the Prosecution / 雄才伟略 / 情妇', '泰隆·鲍华 Tyrone Power / 玛琳·...', '比利·怀尔德 Billy Wilder', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2927451337.jpg', '剧情/犯罪/悬疑/惊悚', '美国', NULL, 1957, NULL, NULL, NULL, 9.60, 763754, 763754, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 20: 寻梦环游记
UPDATE movie SET douban_id='20495023', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='寻梦环游记' AND release_year = 2017 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '20495023', '寻梦环游记', 'Coco / 玩转极乐园(港) / 可可夜总会(台)', '...', '李·昂克里奇 Lee Unkrich / 阿德里安·莫利纳 Adrian Molina', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p2505426431.jpg', '喜剧/动画/奇幻/音乐', '美国', NULL, 2017, NULL, NULL, NULL, 9.10, 2028944, 2028944, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 21: 大话西游之大圣娶亲
UPDATE movie SET douban_id='1292213', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='大话西游之大圣娶亲' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292213', '大话西游之大圣娶亲', '西遊記大結局之仙履奇緣 / 西游记完结篇仙履奇缘 / 齐天大圣西游记', '周星驰 Stephen Chow / 吴孟达 Man Tat Ng...', '刘镇伟 Jeffrey Lau', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2455050536.jpg', '喜剧/爱情/奇幻/古装', '中国香港/中国大陆', NULL, 1995, NULL, NULL, NULL, 9.20, 1732151, 1732151, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 22: 熔炉
UPDATE movie SET douban_id='5912992', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='熔炉' AND release_year = 2011 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '5912992', '熔炉', '도가니 / 无声呐喊(港) / 漩涡', '孔侑 Yoo Gong / 郑有美 Yu-mi Jung /...', '黄东赫 Dong-hyuk Hwang', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1363250216.jpg', '剧情', '韩国', NULL, 2011, NULL, NULL, NULL, 9.30, 1047500, 1047500, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 23: 触不可及
UPDATE movie SET douban_id='6786002', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='触不可及' AND release_year = 2011 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '6786002', '触不可及', 'Intouchables / 闪亮人生(港) / 逆转人生(台)', NULL, '奥利维·那卡什 Olivier Nakache / 艾力克·托兰达 Eric Toledano 主...', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1454261925.jpg', '剧情/喜剧', '法国', NULL, 2011, NULL, NULL, NULL, 9.30, 1316271, 1316271, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 24: 教父
UPDATE movie SET douban_id='1291841', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='教父' AND release_year = 1972 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291841', '教父', 'The Godfather / Mario Puzo''s The Godfather', '马龙·白兰度 M...', '弗朗西斯·福特·科波拉 Francis Ford Coppola', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p616779645.jpg', '剧情/犯罪', '美国', NULL, 1972, NULL, NULL, NULL, 9.30, 1124693, 1124693, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 25: 哈利·波特与魔法石
UPDATE movie SET douban_id='1295038', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哈利·波特与魔法石' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1295038', '哈利·波特与魔法石', 'Harry Potter and the Sorcerer''s Stone / 哈利波特1：神秘的魔法石(港 / 台)', 'Daniel Radcliffe / Emma Watson / Rupert Grint', 'Chris Columbus', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2913781448.jpg', '奇幻/冒险', '美国/英国', NULL, 2001, NULL, NULL, NULL, 9.20, 1448983, 1448983, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 26: 末代皇帝
UPDATE movie SET douban_id='1293172', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='末代皇帝' AND release_year = 1987 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293172', '末代皇帝', 'The Last Emperor / 末代皇帝溥仪(港) / L''ultimo imperatore', '尊龙 John Lone / 陈...', '贝纳尔多·贝托鲁奇 Bernardo Bertolucci', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p452089833.jpg', '剧情/传记/历史', '英国/意大利/中国大陆/法国', NULL, 1987, NULL, NULL, NULL, 9.30, 1045431, 1045431, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 27: 当幸福来敲门
UPDATE movie SET douban_id='1849031', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='当幸福来敲门' AND release_year = 2006 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1849031', '当幸福来敲门', 'The Pursuit of Happyness / 寻找快乐的故事(港) / 追求快乐', '威尔·史密斯 Will Smith ...', '加布里尔·穆奇诺 Gabriele Muccino', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2220721286.jpg', '剧情/传记/家庭', '美国', NULL, 2006, NULL, NULL, NULL, 9.10, 1708789, 1708789, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 28: 龙猫
UPDATE movie SET douban_id='1291560', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='龙猫' AND release_year = 1988 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291560', '龙猫', 'となりのトトロ / 邻居托托罗 / 邻家的豆豆龙', '日高法子 Noriko Hidaka / 坂本千夏 Ch...', '宫崎骏 Hayao Miyazaki', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2540924496.jpg', '动画/奇幻/冒险', '日本', NULL, 1988, NULL, NULL, NULL, 9.20, 1429039, 1429039, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 29: 活着
UPDATE movie SET douban_id='1292365', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='活着' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292365', '活着', '人生 / Lifetimes', '葛优 You Ge / 巩俐 Li Gong / 姜武 Wu Jiang', '张艺谋 Yimou Zhang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2597919477.jpg', '剧情/历史/家庭', '中国大陆/中国香港', NULL, 1994, NULL, NULL, NULL, 9.30, 985822, 985822, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 30: 怦然心动
UPDATE movie SET douban_id='3319755', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='怦然心动' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3319755', '怦然心动', 'Flipped / 萌动青春 / 青春萌动', '玛德琳·卡罗尔 Madeline Carroll / 卡...', '罗伯·莱纳 Rob Reiner', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p501177648.jpg', '剧情/喜剧/爱情', '美国', NULL, 2010, NULL, NULL, NULL, 9.10, 2076824, 2076824, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 31: 蝙蝠侠：黑暗骑士
UPDATE movie SET douban_id='1851857', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='蝙蝠侠：黑暗骑士' AND release_year = 2008 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1851857', '蝙蝠侠：黑暗骑士', 'The Dark Knight / 蝙蝠侠前传2：黑暗骑士 / 黑暗骑士(台)', '克里斯蒂安·贝尔 Christ...', '克里斯托弗·诺兰 Christopher Nolan', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p462657443.jpg', '剧情/动作/科幻/犯罪/惊悚', '美国/英国', NULL, 2008, NULL, NULL, NULL, 9.20, 1214243, 1214243, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 32: 指环王3：王者无敌
UPDATE movie SET douban_id='1291552', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='指环王3：王者无敌' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291552', '指环王3：王者无敌', 'The Lord of the Rings: The Return of the King / 魔戒三部曲：王者再临(台 / 港)', '伊利亚·伍德 Elijah Wood / 西恩...', '彼得·杰克逊 Peter Jackson', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2642829472.jpg', '剧情/动作/奇幻/冒险', '美国/新西兰', NULL, 2003, NULL, NULL, NULL, 9.30, 925033, 925033, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 33: 我不是药神
UPDATE movie SET douban_id='26752088', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='我不是药神' AND release_year = 2018 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26752088', '我不是药神', '中国药神 / 印度药神', '徐峥 Zheng Xu / 王传君 Chuanjun Wang / 周...', '文牧野 Muye Wen', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2527119568.jpg', '剧情/喜剧', '中国大陆', NULL, 2018, NULL, NULL, NULL, 9.00, 2383427, 2383427, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 34: 乱世佳人
UPDATE movie SET douban_id='1300267', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='乱世佳人' AND release_year = 1939 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1300267', '乱世佳人', 'Gone with the Wind / 飘', '费...', '维克多·弗莱明 Victor Fleming / 乔治·库克 George Cukor', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1963126880.jpg', '剧情/历史/爱情/战争', '美国', NULL, 1939, NULL, NULL, NULL, 9.30, 809593, 809593, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 35: 让子弹飞
UPDATE movie SET douban_id='3742360', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='让子弹飞' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3742360', '让子弹飞', '让子弹飞一会儿 / 火烧云', '姜文 Wen Jiang / 葛优 You Ge / 周润发 Yun-F...', '姜文 Wen Jiang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1512562287.jpg', '剧情/喜剧/动作/西部', '中国大陆/中国香港', NULL, 2010, NULL, NULL, NULL, 9.00, 1944860, 1944860, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 36: 飞屋环游记
UPDATE movie SET douban_id='2129039', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='飞屋环游记' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '2129039', '飞屋环游记', 'Up / 冲天救兵(港) / 天外奇迹(台)', '爱德...', '彼特·道格特 Pete Docter / 鲍勃·彼德森 Bob Peterson', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p485887754.jpg', '剧情/喜剧/动画/冒险', '美国', NULL, 2009, NULL, NULL, NULL, 9.10, 1523146, 1523146, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 37: 哈尔的移动城堡
UPDATE movie SET douban_id='1308807', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哈尔的移动城堡' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1308807', '哈尔的移动城堡', 'ハウルの動く城 / 哈尔移动城堡(港) / 霍尔的移动城堡(台)', '倍赏千惠子 Chieko Baishô / 木村拓...', '宫崎骏 Hayao Miyazaki', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2907583906.jpg', '爱情/动画/奇幻/冒险', '日本', NULL, 2004, NULL, NULL, NULL, 9.10, 1315613, 1315613, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 38: 十二怒汉
UPDATE movie SET douban_id='1293182', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='十二怒汉' AND release_year = 1957 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293182', '十二怒汉', '12 Angry Men / 12怒汉 / 十二怒汉', '亨利·方达 Henry Fonda / 马丁...', '西德尼·吕美特 Sidney Lumet', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2173577632.jpg', '剧情', '美国', NULL, 1957, NULL, NULL, NULL, 9.40, 590008, 590008, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 39: 海蒂和爷爷
UPDATE movie SET douban_id='25958717', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='海蒂和爷爷' AND release_year = 2015 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25958717', '海蒂和爷爷', 'Heidi / 飘零燕(港) / 海蒂', '阿努克·斯特芬 Anuk Steffen /...', '阿兰·葛斯彭纳 Alain Gsponer', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2554525534.jpg', '剧情/冒险/家庭', '德国/瑞士', NULL, 2015, NULL, NULL, NULL, 9.30, 803843, 803843, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 40: 素媛
UPDATE movie SET douban_id='21937452', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='素媛' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '21937452', '素媛', '소원 / 许愿 / 希望：为爱重生(台)', '薛景求 Kyung-gu Sol / 严志媛 Ji-won Uhm ...', '李濬益 Jun-ik Lee', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2118532944.jpg', '剧情', '韩国', NULL, 2013, NULL, NULL, NULL, 9.30, 786910, 786910, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 41: 猫鼠游戏
UPDATE movie SET douban_id='1305487', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='猫鼠游戏' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1305487', '猫鼠游戏', 'Catch Me If You Can / 逍遥法外 / 捉智双雄(港)', '莱昂纳多·迪卡普里奥 L...', '史蒂文·斯皮尔伯格 Steven Spielberg', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p453924541.jpg', '传记/犯罪/剧情', '美国/加拿大', NULL, 2002, NULL, NULL, NULL, 9.10, 1232983, 1232983, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 42: 天空之城
UPDATE movie SET douban_id='1291583', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='天空之城' AND release_year = 1986 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291583', '天空之城', '天空の城ラピュタ / 天空之城拉普他 / 空中城堡拉普他', '田中真弓 Mayumi Tanaka / 横泽启子 Ke...', '宫崎骏 Hayao Miyazaki', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p2892409201.jpg', '动画/奇幻/冒险', '日本', NULL, 1986, NULL, NULL, NULL, 9.20, 1023063, 1023063, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 43: 鬼子来了
UPDATE movie SET douban_id='1291858', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='鬼子来了' AND release_year = 2000 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291858', '鬼子来了', 'Devils on the Doorstep', '姜文 Wen Jiang / 香川照之 Teruyuki Kagawa /...', '姜文 Wen Jiang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2930874010.jpg', '剧情/喜剧', '中国大陆', NULL, 2000, NULL, NULL, NULL, 9.30, 727140, 727140, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 44: 摔跤吧！爸爸
UPDATE movie SET douban_id='26387939', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='摔跤吧！爸爸' AND release_year = 2016 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26387939', '摔跤吧！爸爸', 'Dangal / 我和我的冠军女儿(台) / 打死不离3父女(港)', '阿米尔·汗 Aamir Khan / 法缇玛...', '涅提·蒂瓦里 Nitesh Tiwari', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2401676338.jpg', '剧情/传记/运动/家庭', '印度', NULL, 2016, NULL, NULL, NULL, 9.00, 1769472, 1769472, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 45: 少年派的奇幻漂流
UPDATE movie SET douban_id='1929463', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='少年派的奇幻漂流' AND release_year = 2012 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1929463', '少年派的奇幻漂流', 'Life of Pi / 少年Pi的奇幻漂流 / 漂流少年Pi', '苏拉·沙玛 Suraj Sharma / 伊尔凡·可汗 Irrfan...', '李安 Ang Lee', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p1784592701.jpg', '剧情/奇幻/冒险', '美国/中国台湾/英国/加拿大', NULL, 2012, NULL, NULL, NULL, 9.10, 1507087, 1507087, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 46: 死亡诗社
UPDATE movie SET douban_id='1291548', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='死亡诗社' AND release_year = 1989 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291548', '死亡诗社', 'Dead Poets Society / 暴雨骄阳(港) / 春风化雨(台)', '罗宾·威廉姆斯 Robin Williams / 罗伯...', '彼得·威尔 Peter Weir', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2575465690.jpg', '剧情', '美国', NULL, 1989, NULL, NULL, NULL, 9.20, 902115, 902115, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 47: 指环王2：双塔奇兵
UPDATE movie SET douban_id='1291572', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='指环王2：双塔奇兵' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291572', '指环王2：双塔奇兵', 'The Lord of the Rings: The Two Towers / 魔戒二部曲：双城奇谋 / 指环王II：双塔', '伊利亚·伍德 Elijah Wood / 西恩...', '彼得·杰克逊 Peter Jackson', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2640236255.jpg', '剧情/动作/奇幻/冒险', '美国/新西兰', NULL, 2002, NULL, NULL, NULL, 9.20, 871660, 871660, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 48: 钢琴家
UPDATE movie SET douban_id='1296736', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='钢琴家' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1296736', '钢琴家', 'The Pianist / 钢琴战曲(港) / 战地琴人(台)', '艾德里安·布洛迪 Adrien Brod...', '罗曼·波兰斯基 Roman Polanski', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p1381339291.jpg', '剧情/传记/战争/音乐', '英国/法国/波兰/德国/美国', NULL, 2002, NULL, NULL, NULL, 9.30, 762110, 762110, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 49: 大话西游之月光宝盒
UPDATE movie SET douban_id='1299398', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='大话西游之月光宝盒' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1299398', '大话西游之月光宝盒', '西遊記第壹佰零壹回之月光寶盒 / 西游记101回月光宝盒 / 齐天大圣东游记', '周星驰 Stephen Chow / 吴孟达 Man Tat Ng...', '刘镇伟 Jeffrey Lau', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2561721372.jpg', '喜剧/爱情/奇幻/古装', '中国香港/中国大陆', NULL, 1995, NULL, NULL, NULL, 9.00, 1386021, 1386021, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 50: 绿皮书
UPDATE movie SET douban_id='27060077', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='绿皮书' AND release_year = 2018 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '27060077', '绿皮书', 'Green Book / 绿簿旅友(港) / 幸福绿皮书(台)', '维果·莫腾森 Viggo Mortensen /...', '彼得·法雷里 Peter Farrelly', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p2531065411.jpg', '剧情/喜剧/传记/音乐', '美国/中国大陆', NULL, 2018, NULL, NULL, NULL, 8.90, 1922199, 1922199, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 51: 何以为家
UPDATE movie SET douban_id='30170448', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='何以为家' AND release_year = 2018 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '30170448', '何以为家', 'كفرناحوم / 迦百农 / 星仔打官司(港)', '扎因·拉费阿 Zain al-Rafeea / ...', '娜丁·拉巴基 Nadine Labaki', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2875749222.jpg', '剧情', '黎巴嫩/美国/法国/塞浦路斯/卡塔尔/英国', NULL, 2018, NULL, NULL, NULL, 9.10, 1175350, 1175350, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 52: 闻香识女人
UPDATE movie SET douban_id='1298624', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='闻香识女人' AND release_year = 1992 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1298624', '闻香识女人', 'Scent of a Woman / 女人香 / 女人的芳香', '阿尔·帕西诺 Al Pacino / 克里斯...', '马丁·布莱斯 Martin Brest', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2550757929.jpg', '剧情', '美国', NULL, 1992, NULL, NULL, NULL, 9.10, 1037822, 1037822, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 53: 大闹天宫
UPDATE movie SET douban_id='1418019', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='大闹天宫' AND release_year = 1961 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1418019', '大闹天宫', '大闹天宫 上下集 / The Monkey King', '邱岳峰 Yuefeng Qiu / 富润生 Runsheng Fu...', '万籁鸣 Laiming Wan', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2184505167.jpg', '1978(中国大陆)', '1964(中国大陆)', NULL, 1961, NULL, NULL, NULL, 9.40, 518916, 518916, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 54: 黑客帝国
UPDATE movie SET douban_id='1291843', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='黑客帝国' AND release_year = 1999 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291843', '黑客帝国', 'The Matrix / 22世纪杀人网络(港) / 廿二世纪杀人网络(港)', NULL, '安迪·沃卓斯基 Andy Wachowski / 拉娜·沃卓斯基 Lana Wachowski 主...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p451926968.jpg', '动作/科幻', '美国', NULL, 1999, NULL, NULL, NULL, 9.10, 966889, 966889, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 55: 指环王1：护戒使者
UPDATE movie SET douban_id='1291571', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='指环王1：护戒使者' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291571', '指环王1：护戒使者', 'The Lord of the Rings: The Fellowship of the Ring / 指环王1：魔戒再现 / 指环王I：护戒使者', '伊利亚·伍德 Elijah Wood / 西恩...', '彼得·杰克逊 Peter Jackson', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2197698335.jpg', '剧情/动作/奇幻/冒险', '新西兰/美国/英国', NULL, 2001, NULL, NULL, NULL, 9.10, 976128, 976128, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 56: 罗马假日
UPDATE movie SET douban_id='1293839', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='罗马假日' AND release_year = 1953 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293839', '罗马假日', 'Roman Holiday / 金枝玉叶(港) / 罗马假期(台)', '奥黛丽·赫本 Audrey Hepburn / 格...', '威廉·惠勒 William Wyler', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2189265085.jpg', '喜剧/剧情/爱情', '美国', NULL, 1953, NULL, NULL, NULL, 9.10, 1060498, 1060498, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 57: 教父2
UPDATE movie SET douban_id='1299131', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='教父2' AND release_year = 1974 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1299131', '教父2', 'The Godfather: Part II / 教父续集(港) / 教父II', '阿尔·帕西诺 A...', '弗朗西斯·福特·科波拉 Francis Ford Coppola', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2194138787.jpg', '剧情/犯罪', '美国', NULL, 1974, NULL, NULL, NULL, 9.30, 652041, 652041, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 58: 狮子王
UPDATE movie SET douban_id='1301753', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='狮子王' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1301753', '狮子王', 'The Lion King / 狮子王3D', '乔纳森·泰勒·托马...', 'Roger Allers / 罗伯·明可夫 Rob Minkoff', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p726659067.jpg', '动画/冒险/歌舞', '美国', NULL, 1994, NULL, NULL, NULL, 9.10, 975559, 975559, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 59: 天堂电影院
UPDATE movie SET douban_id='1291828', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='天堂电影院' AND release_year = 1988 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291828', '天堂电影院', 'Nuovo Cinema Paradiso / 星光伴我心(港) / 新天堂乐园(台)', '菲利普·努瓦雷 Philipp...', '朱塞佩·托纳多雷 Giuseppe Tornatore', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2653054340.jpg', '剧情/爱情', '意大利/法国', NULL, 1988, NULL, NULL, NULL, 9.20, 751092, 751092, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 60: 饮食男女
UPDATE movie SET douban_id='1291818', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='饮食男女' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291818', '饮食男女', '飲食男女 / Eat Drink Man Woman', '郎雄 Sihung Lung / 杨贵媚 Kuei-Mei Yang / 吴...', '李安 Ang Lee', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p1910899751.jpg', '剧情/家庭', '中国台湾/美国', NULL, 1994, NULL, NULL, NULL, 9.20, 740897, 740897, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 61: 辩护人
UPDATE movie SET douban_id='21937445', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='辩护人' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '21937445', '辩护人', '변호인 / 逆权大状(港) / 正义辩护人(台)', '宋康昊 Kang-ho Song / 金英爱 Yeong-ae...', '杨宇硕 Woo-seok Yang', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2158166535.jpg', '剧情', '韩国', NULL, 2013, NULL, NULL, NULL, 9.20, 665044, 665044, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 62: 本杰明·巴顿奇事
UPDATE movie SET douban_id='1485260', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='本杰明·巴顿奇事' AND release_year = 2008 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1485260', '本杰明·巴顿奇事', 'The Curious Case of Benjamin Button / 奇幻逆缘(港) / 班杰明的奇幻旅程(台)', '布拉德·皮特 Brad Pitt / 凯特·布...', '大卫·芬奇 David Fincher', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2192535722.jpg', '剧情/爱情/奇幻', '美国', NULL, 2008, NULL, NULL, NULL, 9.00, 1119930, 1119930, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 63: 搏击俱乐部
UPDATE movie SET douban_id='1292000', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='搏击俱乐部' AND release_year = 1999 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292000', '搏击俱乐部', 'Fight Club / 搏击会(港) / 斗阵俱乐部(台)', '爱德华·诺顿 Edward Norton / 布拉...', '大卫·芬奇 David Fincher', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1910931622.jpg', '剧情/动作/悬疑/惊悚', '美国', NULL, 1999, NULL, NULL, NULL, 9.00, 994815, 994815, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 64: 美丽心灵
UPDATE movie SET douban_id='1306029', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='美丽心灵' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1306029', '美丽心灵', 'A Beautiful Mind / 有你终生美丽(港) / 美丽境界(台)', '罗素·克劳 Russell Crowe / 艾德·哈...', '朗·霍华德 Ron Howard', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1665997400.jpg', '传记/剧情', '美国', NULL, 2001, NULL, NULL, NULL, 9.10, 862867, 862867, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 65: 穿条纹睡衣的男孩
UPDATE movie SET douban_id='3008247', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='穿条纹睡衣的男孩' AND release_year = 2008 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3008247', '穿条纹睡衣的男孩', 'The Boy in the Striped Pajamas / 穿条纹衣服的男孩 / 穿条纹衣的男孩', '阿萨·巴特菲尔德 Asa Butterfield ...', '马克·赫尔曼 Mark Herman', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1473670352.jpg', '剧情/战争', '英国/美国', NULL, 2008, NULL, NULL, NULL, 9.20, 650914, 650914, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 66: 功夫
UPDATE movie SET douban_id='1291543', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='功夫' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291543', '功夫', '功夫3D / Kung Fu Hustle', '周星驰 Stephen Chow / 元秋 Qiu Yuen / ...', '周星驰 Stephen Chow', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2219011938.jpg', '动作/喜剧/犯罪/奇幻', '中国大陆/中国香港', NULL, 2004, NULL, NULL, NULL, 8.90, 1367357, 1367357, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 67: 哈利·波特与死亡圣器(下)
UPDATE movie SET douban_id='3011235', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哈利·波特与死亡圣器(下)' AND release_year = 2011 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3011235', '哈利·波特与死亡圣器(下)', 'Harry Potter and the Deathly Hallows: Part 2 / 哈利波特7：死神的圣物2(港 / 台)', '丹尼尔·雷德克里夫 Daniel Radcliffe...', '大卫·叶茨 David Yates', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2913457020.jpg', '奇幻/冒险', '美国/英国', NULL, 2011, NULL, NULL, NULL, 9.00, 987050, 987050, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 68: 两杆大烟枪
UPDATE movie SET douban_id='1293350', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='两杆大烟枪' AND release_year = 1998 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293350', '两杆大烟枪', 'Lock, Stock and Two Smoking Barrels / 够姜四小强(港) / 两根枪管(台)', '杰森·弗莱明 Jason Flemyng / 德克斯特...', '盖·里奇 Guy Ritchie', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792443418.jpg', '剧情/喜剧/犯罪', '英国', NULL, 1998, NULL, NULL, NULL, 9.10, 689187, 689187, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 69: 情书
UPDATE movie SET douban_id='1292220', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='情书' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292220', '情书', 'Love Letter / When I Close My Eyes / Letters of Love', '中山美穗 Miho Nakayama / 丰川悦司 Ets...', '岩井俊二 Shunji Iwai', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2648230660.jpg', '剧情/爱情', '日本', NULL, 1995, NULL, NULL, NULL, 8.90, 1346915, 1346915, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 70: 音乐之声
UPDATE movie SET douban_id='1294408', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='音乐之声' AND release_year = 1965 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1294408', '音乐之声', 'The Sound of Music / 仙乐飘飘处处闻(港) / 真善美(台)', '朱莉·安德鲁斯 Julie Andrews / 克...', '罗伯特·怀斯 Robert Wise', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2585102899.jpg', '剧情/传记/爱情/歌舞', '美国', NULL, 1965, NULL, NULL, NULL, 9.10, 694913, 694913, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 71: 窃听风暴
UPDATE movie SET douban_id='1900841', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='窃听风暴' AND release_year = 2006 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1900841', '窃听风暴', 'Das Leben der Anderen / 窃听者(港) / 他人的生活', NULL, '弗洛里安·亨克尔·冯·多纳斯马尔克 Florian Henckel von Donnersmarck &n...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1808872109.jpg', '剧情/悬疑', '德国', NULL, 2006, NULL, NULL, NULL, 9.20, 640510, 640510, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 72: 哈利·波特与阿兹卡班的囚徒
UPDATE movie SET douban_id='1291544', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哈利·波特与阿兹卡班的囚徒' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291544', '哈利·波特与阿兹卡班的囚徒', 'Harry Potter and the Prisoner of Azkaban / 哈利波特3：阿兹卡班的逃犯(港 / 台)', '丹尼尔·雷德克里夫 Daniel Rad...', '阿方索·卡隆 Alfonso Cuarón', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2913456870.jpg', '奇幻/冒险', '英国/美国', NULL, 2004, NULL, NULL, NULL, 9.00, 908800, 908800, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 73: 阿凡达
UPDATE movie SET douban_id='1652587', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='阿凡达' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1652587', '阿凡达', 'Avatar', '萨姆·沃辛顿 Sam Worthington ...', '詹姆斯·卡梅隆 James Cameron', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2180085848.jpg', '动作/科幻/冒险', '美国', NULL, 2009, NULL, NULL, NULL, 8.80, 1605286, 1605286, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 74: 西西里的美丽传说
UPDATE movie SET douban_id='1292402', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='西西里的美丽传说' AND release_year = 2000 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292402', '西西里的美丽传说', 'Malèna / 真爱伴我行(台) / 玛莲娜', '莫妮卡·贝鲁奇 Monica ...', '朱塞佩·托纳多雷 Giuseppe Tornatore', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2441988159.jpg', '剧情/战争/情色', '意大利/美国', NULL, 2000, NULL, NULL, NULL, 8.90, 1106949, 1106949, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 75: 看不见的客人
UPDATE movie SET douban_id='26580232', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='看不见的客人' AND release_year = 2016 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26580232', '看不见的客人', 'Contratiempo / 死无对证(港) / 布局(台)', '马里奥·卡萨斯 Mario Casas / 阿...', '奥里奥尔·保罗 Oriol Paulo', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2498971355.jpg', '剧情/犯罪/悬疑/惊悚', '西班牙', NULL, 2016, NULL, NULL, NULL, 8.80, 1461650, 1461650, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 76: 拯救大兵瑞恩
UPDATE movie SET douban_id='1292849', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='拯救大兵瑞恩' AND release_year = 1998 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292849', '拯救大兵瑞恩', 'Saving Private Ryan / 雷霆救兵(港) / 抢救雷恩大兵(台)', '汤姆·汉克斯 Tom Hanks...', '史蒂文·斯皮尔伯格 Steven Spielberg', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1014542496.jpg', '剧情/战争', '美国', NULL, 1998, NULL, NULL, NULL, 9.10, 738619, 738619, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 77: 沉默的羔羊
UPDATE movie SET douban_id='1293544', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='沉默的羔羊' AND release_year = 1991 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293544', '沉默的羔羊', 'The Silence of the Lambs / 沉默的羔羊', '朱迪·福斯特 Jodie Foster / 安...', '乔纳森·戴米 Jonathan Demme', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1593414327.jpg', '剧情/犯罪/惊悚', '美国', NULL, 1991, NULL, NULL, NULL, 8.90, 1032105, 1032105, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 78: 小鞋子
UPDATE movie SET douban_id='1303021', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='小鞋子' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1303021', '小鞋子', 'بچه های آسمان / 天堂的孩子 / 小童鞋', '默罕默德·阿米尔·纳吉 Mohamma...', '马基德·马基迪 Majid Majidi', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2165511465.jpg', '剧情/儿童/家庭', '伊朗', NULL, 1997, NULL, NULL, NULL, 9.20, 475640, 475640, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 79: 还有明天
UPDATE movie SET douban_id='36445098', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='还有明天' AND release_year = 2023 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '36445098', '还有明天', 'C''è ancora domani / 明天还有梦(港) / 我们还有明天(台)', '宝拉·柯特莱西 Paola Corte...', '宝拉·柯特莱西 Paola Cortellesi', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2918279456.jpg', '剧情/喜剧/历史', '意大利', NULL, 2023, NULL, NULL, NULL, 9.30, 391528, 391528, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 80: 蝴蝶效应
UPDATE movie SET douban_id='1292343', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='蝴蝶效应' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292343', '蝴蝶效应', 'The Butterfly Effect / 蝴蝶效应', NULL, '埃里克·布雷斯 Eric Bress / J·麦基·格鲁伯 J. Mackye Gruber 主...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2209066019.jpg', '剧情/悬疑/科幻/惊悚', '美国/加拿大', NULL, 2004, NULL, NULL, NULL, 8.90, 1086028, 1086028, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 81: 布达佩斯大饭店
UPDATE movie SET douban_id='11525673', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='布达佩斯大饭店' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '11525673', '布达佩斯大饭店', 'The Grand Budapest Hotel / 布达佩斯大酒店(港) / 欢迎来到布达佩斯大饭店(台)', '拉尔夫·费因斯 Ralph Fiennes / ...', '韦斯·安德森 Wes Anderson', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2183539003.jpg', '剧情/喜剧/冒险', '美国/德国/英国', NULL, 2014, NULL, NULL, NULL, 8.90, 1102814, 1102814, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 82: 飞越疯人院
UPDATE movie SET douban_id='1292224', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='飞越疯人院' AND release_year = 1975 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292224', '飞越疯人院', 'One Flew Over the Cuckoo''s Nest / 飞越杜鹃窝(台) / 飞越喜鹊巢', '杰克·尼科尔森 Jack Nichols...', '米洛斯·福尔曼 Miloš Forman', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792238287.jpg', '剧情', '美国', NULL, 1975, NULL, NULL, NULL, 9.10, 612976, 612976, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 83: 禁闭岛
UPDATE movie SET douban_id='2334904', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='禁闭岛' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '2334904', '禁闭岛', 'Shutter Island / 不赦岛(港) / 隔离岛(台)', '莱昂纳多·迪卡普里奥 Leonardo DiCaprio / ...', 'Martin Scorsese', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p450262388.jpg', '剧情/悬疑/惊悚', '美国', NULL, 2010, NULL, NULL, NULL, 8.90, 1132595, 1132595, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 84: 心灵捕手
UPDATE movie SET douban_id='1292656', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='心灵捕手' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292656', '心灵捕手', 'Good Will Hunting / 骄阳似我(港) / 心灵捕手', '马特·达蒙 Matt Damon / 罗宾·...', '格斯·范·桑特 Gus Van Sant', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p480965695.jpg', '剧情', '美国', NULL, 1997, NULL, NULL, NULL, 9.00, 828902, 828902, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 85: 致命魔术
UPDATE movie SET douban_id='1780330', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='致命魔术' AND release_year = 2006 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1780330', '致命魔术', 'The Prestige / 死亡魔法(港) / 顶尖对决(台)', '休·杰克曼 Hugh Jackman...', '克里斯托弗·诺兰 Christopher Nolan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p480383375.jpg', '剧情/悬疑/惊悚', '英国/美国', NULL, 2006, NULL, NULL, NULL, 8.90, 981695, 981695, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 86: 低俗小说
UPDATE movie SET douban_id='1291832', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='低俗小说' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291832', '低俗小说', 'Pulp Fiction / 危险人物(港) / 黑色追缉令(台)', '约翰·特拉沃尔塔 John Tra...', '昆汀·塔伦蒂诺 Quentin Tarantino', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1910902213.jpg', '剧情/喜剧/犯罪', '美国', NULL, 1994, NULL, NULL, NULL, 8.90, 977002, 977002, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 87: 哈利·波特与密室
UPDATE movie SET douban_id='1296996', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哈利·波特与密室' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1296996', '哈利·波特与密室', 'Harry Potter and the Chamber of Secrets / 哈利波特2：消失的密室(港 / 台)', '丹尼尔·雷德克里夫 Daniel Radcliffe / 艾玛...', 'Chris Columbus', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p2913781951.jpg', '奇幻/冒险', '英国/美国', NULL, 2002, NULL, NULL, NULL, 8.90, 935896, 935896, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 88: 一一
UPDATE movie SET douban_id='1292434', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='一一' AND release_year = 2000 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292434', '一一', 'Yi yi / Yi yi: A One and a Two', '吴念真 / 李凯莉 Kelly Lee / 金燕玲 Elai...', '杨德昌 Edward Yang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2923629857.jpg', '剧情/爱情/家庭', '中国台湾/日本', NULL, 2000, NULL, NULL, NULL, 9.10, 529902, 529902, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 89: 超脱
UPDATE movie SET douban_id='5322596', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='超脱' AND release_year = 2011 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '5322596', '超脱', 'Detachment / 人间师格(台)', '艾德里安·布洛迪 Adrien Brody / 马西...', '托尼·凯耶 Tony Kaye', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p1305562621.jpg', '剧情', '美国', NULL, 2011, NULL, NULL, NULL, 9.00, 736803, 736803, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 90: 喜剧之王
UPDATE movie SET douban_id='1302425', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='喜剧之王' AND release_year = 1999 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1302425', '喜剧之王', '喜劇之王 / King of Comedy', '周星驰 Stephen Ch...', '周星驰 Stephen Chow / 李力持 Lik-Chi Lee', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2917778954.jpg', '喜剧/剧情/爱情', '中国香港', NULL, 1999, NULL, NULL, NULL, 8.80, 1116748, 1116748, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 91: 致命ID
UPDATE movie SET douban_id='1297192', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='致命ID' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297192', '致命ID', 'Identity / 杀人游戏 / 致命身份', '约翰·库萨克 John Cusack / 雷...', '詹姆斯·曼高德 James Mangold', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2497887020.jpg', '剧情/悬疑/惊悚', '美国', NULL, 2003, NULL, NULL, NULL, 8.90, 969667, 969667, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 92: 杀人回忆
UPDATE movie SET douban_id='1300299', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='杀人回忆' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1300299', '杀人回忆', '살인의 추억 / 谋杀回忆 / 杀手回忆录', '宋康昊 Kang-ho Song / 金相庆 Sang-kyun...', '奉俊昊 Joon-ho Bong', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1633113220.jpg', '剧情/动作/犯罪/悬疑/惊悚', '韩国', NULL, 2003, NULL, NULL, NULL, 8.90, 854088, 854088, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 93: 摩登时代
UPDATE movie SET douban_id='1294371', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='摩登时代' AND release_year = 1936 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1294371', '摩登时代', 'Modern Times / The Masses / Les Temps modernes', '查理·卓别林 Charles Chaplin ...', '查理·卓别林 Charles Chaplin', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2263408369.jpg', '剧情/喜剧/爱情', '美国', NULL, 1936, NULL, NULL, NULL, 9.30, 353688, 353688, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 94: 加勒比海盗
UPDATE movie SET douban_id='1298070', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='加勒比海盗' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1298070', '加勒比海盗', 'Pirates of the Caribbean: The Curse of the Black Pearl / 加勒比海盗1：黑珍珠号的诅咒 / 神鬼奇航：鬼盗船魔咒(台)', '约翰尼·德普 Johnny Depp / ...', '戈尔·维宾斯基 Gore Verbinski', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1596085504.jpg', '动作/冒险/奇幻', '美国', NULL, 2003, NULL, NULL, NULL, 8.90, 986200, 986200, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 95: 春光乍泄
UPDATE movie SET douban_id='1292679', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='春光乍泄' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292679', '春光乍泄', '春光乍洩 / 一起快乐 / Happy Together', '张国荣 Leslie Cheung / 梁朝伟 Tony Leu...', '王家卫 Kar Wai Wong', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p465939041.jpg', '剧情/爱情/同性', '中国香港/日本/韩国', NULL, 1997, NULL, NULL, NULL, 9.00, 719058, 719058, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 96: 海豚湾
UPDATE movie SET douban_id='3442220', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='海豚湾' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3442220', '海豚湾', 'The Cove / 血色海湾(台) / 海湾', '路易·西霍尤斯 Louie Psihoyo...', '路易·西霍尤斯 Louie Psihoyos', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2559579779.jpg', '纪录片', '美国', NULL, 2009, NULL, NULL, NULL, 9.30, 385866, 385866, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 97: 美国往事
UPDATE movie SET douban_id='1292262', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='美国往事' AND release_year = 1984 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292262', '美国往事', 'Once Upon a Time in America / 四海兄弟(台) / 义薄云天(港)', '罗伯特·德尼罗 Robert De Niro ...', '赛尔乔·莱翁内 Sergio Leone', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p477229647.jpg', '犯罪/剧情', '美国/意大利', NULL, 1984, NULL, NULL, NULL, 9.10, 480488, 480488, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 98: 七宗罪
UPDATE movie SET douban_id='1292223', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='七宗罪' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292223', '七宗罪', 'Se7en / 火线追缉令(台) / 7宗罪', '摩根·弗里曼 Morgan Freeman / 布...', '大卫·芬奇 David Fincher', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2219586434.jpg', '剧情/犯罪/悬疑/惊悚', '美国', NULL, 1995, NULL, NULL, NULL, 8.80, 1082529, 1082529, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 99: 红辣椒
UPDATE movie SET douban_id='1865703', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='红辣椒' AND release_year = 2006 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1865703', '红辣椒', 'パプリカ / 盗梦侦探(港 / 台)', '林原惠美 Megumi Hayashibara / 江守彻 Toru...', '今敏 Satoshi Kon', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2794776839.jpg', '动画/悬疑/科幻/惊悚', '日本', NULL, 2006, NULL, NULL, NULL, 9.00, 584240, 584240, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 100: 唐伯虎点秋香
UPDATE movie SET douban_id='1306249', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='唐伯虎点秋香' AND release_year = 1993 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1306249', '唐伯虎点秋香', '唐伯虎點秋香 / Flirting Scholar', '周星驰 Stephen Chow / 巩俐 Li Gong / 陈...', '李力持 Lik-Chi Lee', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2357915564.jpg', '喜剧/爱情/古装', '中国香港', NULL, 1993, NULL, NULL, NULL, 8.80, 1246556, 1246556, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 101: 狩猎
UPDATE movie SET douban_id='6985810', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='狩猎' AND release_year = 2012 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '6985810', '狩猎', 'Jagten / 诬网(港) / 谎言的烙印(台)', '麦斯·米科尔森 Mads Mik...', '托马斯·温特伯格 Thomas Vinterberg', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1546987967.jpg', '剧情', '丹麦/瑞典', NULL, 2012, NULL, NULL, NULL, 9.10, 481378, 481378, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 102: 寄生虫
UPDATE movie SET douban_id='27010768', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='寄生虫' AND release_year = 2019 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '27010768', '寄生虫', '기생충 / 寄生上流(台) / 上流寄生族(港)', '宋康昊 Kang-ho Song / 李善均 Seon-gyun...', '奉俊昊 Joon-ho Bong', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2561439800.jpg', '剧情', '韩国', NULL, 2019, NULL, NULL, NULL, 8.80, 1572209, 1572209, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 103: 幽灵公主
UPDATE movie SET douban_id='1297359', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='幽灵公主' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297359', '幽灵公主', 'もののけ姫 / 魔法公主 / 幽灵少女', '松田洋治 Yôji Matsuda / 石田百合...', '宫崎骏 Hayao Miyazaki', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2920895053.jpg', '动画/奇幻/冒险', '日本', NULL, 1997, NULL, NULL, NULL, 8.90, 682034, 682034, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 104: 甜蜜蜜
UPDATE movie SET douban_id='1305164', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='甜蜜蜜' AND release_year = 1996 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1305164', '甜蜜蜜', 'Comrades: Almost a Love Story', '黎明 Leon Lai / 张曼玉 Maggie Cheung / ...', '陈可辛 Peter Chan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2223011274.jpg', '剧情/爱情', '中国香港', NULL, 1996, NULL, NULL, NULL, 8.90, 687324, 687324, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 105: 蝙蝠侠：黑暗骑士崛起
UPDATE movie SET douban_id='3395373', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='蝙蝠侠：黑暗骑士崛起' AND release_year = 2012 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3395373', '蝙蝠侠：黑暗骑士崛起', 'The Dark Knight Rises / 蝙蝠侠前传3：黑暗骑士崛起 / 黑暗骑士：黎明升起(台)', '克里斯蒂安·贝尔 Christ...', '克里斯托弗·诺兰 Christopher Nolan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1706428744.jpg', '剧情/动作/科幻/犯罪/惊悚', '美国/英国', NULL, 2012, NULL, NULL, NULL, 8.90, 831984, 831984, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 106: 天书奇谭
UPDATE movie SET douban_id='1428581', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='天书奇谭' AND release_year = 1983 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1428581', '天书奇谭', '天书奇谭4K纪念版 / The Legend of Sealed Book', '丁建华 Jianhua Din...', '王树忱 Shuchen Wang / 钱运达 Yunda Qian', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2700138245.jpg', '中国大陆', '2021', NULL, 1983, NULL, NULL, NULL, 9.20, 344726, 344726, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 107: 超能陆战队
UPDATE movie SET douban_id='11026735', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='超能陆战队' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '11026735', '超能陆战队', 'Big Hero 6 / 大英雄联盟(港) / 大英雄天团(台)', '斯科特...', '唐·霍尔 Don Hall / 克里斯·威廉姆斯 Chris Williams', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2224568669.jpg', '喜剧/动作/科幻/动画/冒险', '美国', NULL, 2014, NULL, NULL, NULL, 8.80, 1165572, 1165572, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 108: 茶馆
UPDATE movie SET douban_id='1461403', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='茶馆' AND release_year = 1982 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1461403', '茶馆', 'The Teahouse', '于是之 Shizhi Yu / 郑榕 Rong Zhen / 蓝天野 T...', '谢添 Tian Xie', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2528965424.jpg', '剧情/历史', '中国大陆', NULL, 1982, NULL, NULL, NULL, 9.50, 218580, 218580, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 109: 第六感
UPDATE movie SET douban_id='1297630', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='第六感' AND release_year = 1999 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297630', '第六感', 'The Sixth Sense / 鬼眼(港) / 灵异第六感(台)', '布鲁斯·威利斯 Bruce Wi...', 'M·奈特·沙马兰 M. Night Shyamalan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2220184425.jpg', '剧情/悬疑/惊悚', '美国', NULL, 1999, NULL, NULL, NULL, 8.90, 652276, 652276, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 110: 7号房的礼物
UPDATE movie SET douban_id='10777687', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='7号房的礼物' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '10777687', '7号房的礼物', '7번방의 선물 / 戆爸的礼物(港) / 7号囚房的礼物', '柳承龙 Seung-yong Ryoo / 朴信惠 Shi...', '李焕庆 Hwan-kyeong Lee', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1816276065.jpg', '剧情/喜剧/家庭', '韩国', NULL, 2013, NULL, NULL, NULL, 8.90, 631251, 631251, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 111: 爱在日落黄昏时
UPDATE movie SET douban_id='1291990', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='爱在日落黄昏时' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291990', '爱在日落黄昏时', 'Before Sunset / 日落巴黎(港) / 爱在日落巴黎时(台)', '伊桑·霍克 Ethan Hawke ...', '理查德·林克莱特 Richard Linklater', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2191788134.jpg', '剧情/爱情', '美国/法国', NULL, 2004, NULL, NULL, NULL, 8.90, 669381, 669381, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 112: 爱在黎明破晓前
UPDATE movie SET douban_id='1296339', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='爱在黎明破晓前' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1296339', '爱在黎明破晓前', 'Before Sunrise / 情留半天(港) / 爱在黎明破晓时(台)', '伊桑·霍克 Ethan Hawke ...', '理查德·林克莱特 Richard Linklater', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2555762374.jpg', '剧情/爱情', '美国/奥地利/瑞士', NULL, 1995, NULL, NULL, NULL, 8.80, 820024, 820024, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 113: 头脑特工队
UPDATE movie SET douban_id='10533913', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='头脑特工队' AND release_year = 2015 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '10533913', '头脑特工队', 'Inside Out / 玩转脑朋友(港) / 脑筋急转弯(台)', NULL, '彼特·道格特 Pete Docter / 罗纳尔多·德尔·卡门 Ronaldo Del Carmen &nb...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2874927470.jpg', '喜剧/动画/冒险', '美国', NULL, 2015, NULL, NULL, NULL, 8.90, 826777, 826777, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 114: 哈利·波特与火焰杯
UPDATE movie SET douban_id='1309055', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哈利·波特与火焰杯' AND release_year = 2005 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1309055', '哈利·波特与火焰杯', 'Harry Potter and the Goblet of Fire / 哈利波特4：火杯的考验(港 / 台)', '丹尼尔·雷德克里夫 Daniel Radclif...', '迈克·内威尔 Mike Newell', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2913456904.jpg', '悬疑/奇幻/冒险', '英国/美国', NULL, 2005, NULL, NULL, NULL, 8.80, 820659, 820659, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 115: 未麻的部屋
UPDATE movie SET douban_id='1395091', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='未麻的部屋' AND release_year = 1997 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1395091', '未麻的部屋', 'Perfect Blue / 蓝色恐惧(港 / 台)', '岩男润子 Junko Iwao / 松本梨香 Rica Matsu...', '今敏 Satoshi Kon', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1351050722.jpg', '剧情/犯罪/动画/悬疑/惊悚', '日本', NULL, 1997, NULL, NULL, NULL, 9.10, 436535, 436535, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 116: 被嫌弃的松子的一生
UPDATE movie SET douban_id='1787291', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='被嫌弃的松子的一生' AND release_year = 2006 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1787291', '被嫌弃的松子的一生', '嫌われ松子の一生 / 花样奇缘(港) / 令人讨厌的松子的一生(台)', '中谷美纪 Miki Nakatani / 瑛太 E...', '中岛哲也 Tetsuya Nakashima', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p884763596.jpg', '剧情/歌舞', '日本', NULL, 2006, NULL, NULL, NULL, 8.80, 784621, 784621, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 117: 重庆森林
UPDATE movie SET douban_id='1291999', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='重庆森林' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291999', '重庆森林', '重慶森林 / Chungking Express', '林青霞 Brigitte Lin / 金城武 Takeshi K...', '王家卫 Kar Wai Wong', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p792381411.jpg', '剧情/爱情', '中国香港', NULL, 1994, NULL, NULL, NULL, 8.80, 937724, 937724, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 118: 借东西的小人阿莉埃蒂
UPDATE movie SET douban_id='4202302', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='借东西的小人阿莉埃蒂' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '4202302', '借东西的小人阿莉埃蒂', '借りぐらしのアリエッティ / 借物少女艾莉缇(台) / 借东西的小矮人亚莉亚蒂(港)', '志田未来 Mirai Shida / 神木...', '米林宏昌 Hiromasa Yonebayashi', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p617533616.jpg', '动画/奇幻/冒险', '日本', NULL, 2010, NULL, NULL, NULL, 8.90, 638986, 638986, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 119: 菊次郎的夏天
UPDATE movie SET douban_id='1293359', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='菊次郎的夏天' AND release_year = 1999 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293359', '菊次郎的夏天', '菊次郎の夏 / 菊次郎之夏 / Kikujirô no natsu', '北野武 Takeshi Kitano / 关口雄介 Yus...', '北野武 Takeshi Kitano', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2620392435.jpg', '剧情/喜剧', '日本', NULL, 1999, NULL, NULL, NULL, 8.90, 685673, 685673, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 120: 入殓师
UPDATE movie SET douban_id='2149806', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='入殓师' AND release_year = 2008 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '2149806', '入殓师', 'おくりびと / 礼仪师之奏鸣曲(港) / 礼仪师(台)', '本木雅弘 Masahiro Motoki / ...', '泷田洋二郎 Yôjirô Takita', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2707581855.jpg', '剧情', '日本', NULL, 2008, NULL, NULL, NULL, 8.90, 751484, 751484, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 121: 断背山
UPDATE movie SET douban_id='1418834', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='断背山' AND release_year = 2005 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1418834', '断背山', 'Brokeback Mountain / 断臂山 / BBM', '希斯·莱杰 Heath Ledger / 杰克·吉伦哈尔 Jake...', '李安 Ang Lee', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2169104127.jpg', '剧情/爱情/同性/家庭', '美国/加拿大', NULL, 2005, NULL, NULL, NULL, 8.80, 796086, 796086, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 122: 剪刀手爱德华
UPDATE movie SET douban_id='1292370', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='剪刀手爱德华' AND release_year = 1990 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292370', '剪刀手爱德华', 'Edward Scissorhands / 幻海奇缘(港) / 剪刀手爱德华', '约翰尼·德普 Johnny Depp / 薇诺娜·...', '蒂姆·波顿 Tim Burton', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p480956937.jpg', '剧情/爱情/奇幻', '美国', NULL, 1990, NULL, NULL, NULL, 8.70, 1133125, 1133125, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 123: 时空恋旅人
UPDATE movie SET douban_id='10577869', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='时空恋旅人' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '10577869', '时空恋旅人', 'About Time / 回到最爱的一天(港) / 真爱每一天(台)', '多姆纳尔·格里森 Domhnall Gl...', '理查德·柯蒂斯 Richard Curtis', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2070153774.jpg', '喜剧/爱情/奇幻', '英国/美国', NULL, 2013, NULL, NULL, NULL, 8.80, 811260, 811260, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 124: 勇敢的心
UPDATE movie SET douban_id='1294639', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='勇敢的心' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1294639', '勇敢的心', 'Braveheart / 惊世未了缘(港) / 梅尔吉勃逊之英雄本色(台)', '梅尔·吉布森 Mel Gibson / 苏菲·玛...', '梅尔·吉布森 Mel Gibson', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2004174709.jpg', '动作/传记/剧情/历史/战争', '美国', NULL, 1995, NULL, NULL, NULL, 8.90, 613019, 613019, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 125: 玩具总动员3
UPDATE movie SET douban_id='1858711', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='玩具总动员3' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1858711', '玩具总动员3', 'Toy Story 3 / 反斗奇兵3(港) / 玩具的故事3', '汤姆·汉克斯 Tom Hanks / 蒂姆·艾...', '李·昂克里奇 Lee Unkrich', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1283675359.jpg', '喜剧/动画/奇幻/冒险', '美国', NULL, 2010, NULL, NULL, NULL, 8.90, 612951, 612951, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 126: 傲慢与偏见
UPDATE movie SET douban_id='1418200', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='傲慢与偏见' AND release_year = 2005 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1418200', '傲慢与偏见', 'Pride & Prejudice / 傲慢与偏见2005 / Pride And Prejudice', '凯拉·奈特莉 Keira Knightley / 马修·...', '乔·怀特 Joe Wright', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2016401659.jpg', '剧情/爱情', '法国/英国/美国', NULL, 2005, NULL, NULL, NULL, 8.70, 960295, 960295, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 127: 驯龙高手
UPDATE movie SET douban_id='2353023', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='驯龙高手' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '2353023', '驯龙高手', 'How to Train Your Dragon / 驯龙记(港)', '...', '迪恩·德布洛斯 Dean DeBlois / 克里斯·桑德斯 Chris Sanders', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2210954024.jpg', '动画/奇幻/冒险', '美国', NULL, 2010, NULL, NULL, NULL, 8.80, 882853, 882853, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 128: 新世界
UPDATE movie SET douban_id='10437779', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='新世界' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '10437779', '新世界', '신세계 / 暗黑新世界(台) / New World', '李政宰 Jung-Jae Lee / 崔岷植 Min-sik...', '朴勋政 Hoon-jung Park', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1903379979.jpg', '剧情/犯罪', '韩国', NULL, 2013, NULL, NULL, NULL, 8.90, 541061, 541061, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 129: 消失的爱人
UPDATE movie SET douban_id='21318488', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='消失的爱人' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '21318488', '消失的爱人', 'Gone Girl / 失踪的女孩 / 失踪女孩', '本·阿弗莱克 Ben Affleck / 罗莎蒙...', '大卫·芬奇 David Fincher', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2221768894.jpg', '剧情/犯罪/悬疑/惊悚', '美国', NULL, 2014, NULL, NULL, NULL, 8.70, 1090388, 1090388, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 130: 无人知晓
UPDATE movie SET douban_id='1292337', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='无人知晓' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292337', '无人知晓', '誰も知らない / 谁知赤子心(港) / 无人知晓的夏日清晨(台)', '柳乐优弥 Yûya Yagira / 北浦爱...', '是枝裕和 Hirokazu Koreeda', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p661160053.jpg', '剧情', '日本', NULL, 2004, NULL, NULL, NULL, 9.10, 380147, 380147, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 131: 倩女幽魂
UPDATE movie SET douban_id='1297447', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='倩女幽魂' AND release_year = 1987 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297447', '倩女幽魂', '倩女幽魂(87版) / 倩女幽魂：妖魔道', '张国荣 Leslie Cheung / 王祖贤 Joey W...', '程小东 Siu-Tung Ching', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2918554634.jpg', '爱情/奇幻/武侠/古装', '中国香港', NULL, 1987, NULL, NULL, NULL, 8.80, 848197, 848197, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 132: 花样年华
UPDATE movie SET douban_id='1291557', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='花样年华' AND release_year = 2000 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291557', '花样年华', '花樣年華 / 花样年华导演特别版 / 花样年华4K修复版', '张曼玉 Maggie Cheung / 梁朝伟 Tony Leu...', '王家卫 Kar Wai Wong', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2918312477.jpg', '剧情/爱情', '中国香港', NULL, 2000, NULL, NULL, NULL, 8.80, 823663, 823663, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 133: 色，戒
UPDATE movie SET douban_id='1828115', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='色，戒' AND release_year = 2007 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1828115', '色，戒', '色|戒 / 色·戒', '梁朝伟 Tony Leung Chiu Wai / 汤唯 Wei Tang / ...', '李安 Ang Lee', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p453716305.jpg', '剧情/爱情/情色', '中国台湾/中国大陆/美国/中国香港', NULL, 2007, NULL, NULL, NULL, 8.70, 982755, 982755, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 134: 一个叫欧维的男人决定去死
UPDATE movie SET douban_id='26628357', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='一个叫欧维的男人决定去死' AND release_year = 2015 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26628357', '一个叫欧维的男人决定去死', 'En man som heter Ove / 明天别再来敲门(台) / 想死冇咁易(港)', '罗夫·拉斯加德 Rolf Lassgård...', '汉内斯·赫尔姆 Hannes Holm', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2406624993.jpg', '剧情', '瑞典', NULL, 2015, NULL, NULL, NULL, 8.90, 582434, 582434, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 135: 怪兽电力公司
UPDATE movie SET douban_id='1291579', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='怪兽电力公司' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291579', '怪兽电力公司', 'Monsters, Inc. / 怪兽公司(港) / 怪物公司', '约...', '彼特·道格特 Pete Docter / 大卫·斯沃曼 David Silverman', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2513247938.jpg', '儿童/喜剧/动画/奇幻/冒险', '美国', NULL, 2001, NULL, NULL, NULL, 8.80, 785143, 785143, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 136: 完美的世界
UPDATE movie SET douban_id='1300992', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='完美的世界' AND release_year = 1993 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1300992', '完美的世界', 'A Perfect World / 强盗保镳', '凯文·科斯特纳 Kevin Cos...', '克林特·伊斯特伍德 Clint Eastwood', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2190556408.jpg', '剧情/犯罪', '美国', NULL, 1993, NULL, NULL, NULL, 9.10, 366908, 366908, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 137: 教父3
UPDATE movie SET douban_id='1294240', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='教父3' AND release_year = 1990 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1294240', '教父3', 'The Godfather: Part III / 教父第三集 / 教父 III', '阿尔·帕西诺 A...', '弗朗西斯·福特·科波拉 Francis Ford Coppola', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p2169664351.jpg', '剧情/犯罪', '美国', NULL, 1990, NULL, NULL, NULL, 9.00, 442130, 442130, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 138: 九品芝麻官
UPDATE movie SET douban_id='1297518', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='九品芝麻官' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297518', '九品芝麻官', '九品芝麻官之白面包青天 / Hail the Judge', '周星驰 Stephen Chow / 吴孟达 Man Tat Ng / ...', '王晶 Jing Wong', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p648370300.jpg', '剧情/喜剧/古装', '中国香港', NULL, 1994, NULL, NULL, NULL, 8.80, 813443, 813443, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 139: 小森林 夏秋篇
UPDATE movie SET douban_id='25814705', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='小森林 夏秋篇' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25814705', '小森林 夏秋篇', 'リトル・フォレスト 夏・秋 / 小森食光 / 夏秋篇(台)', '桥本爱 Ai Hashimoto / 三浦贵大 Takahir...', '森淳一 Junichi Mori', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2232317770.jpg', '剧情', '日本', NULL, 2014, NULL, NULL, NULL, 9.00, 481710, 481710, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 140: 天使爱美丽
UPDATE movie SET douban_id='1292215', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='天使爱美丽' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292215', '天使爱美丽', 'Le Fabuleux destin d''Amélie Poulain / 艾蜜莉的异想世界(台) / 天使艾米莉', '奥黛丽·塔图 Audrey Tau...', '让-皮埃尔·热内 Jean-Pierre Jeunet', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2447590313.jpg', '剧情/喜剧/爱情', '法国/德国', NULL, 2001, NULL, NULL, NULL, 8.70, 1031686, 1031686, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 141: 阳光灿烂的日子
UPDATE movie SET douban_id='1291875', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='阳光灿烂的日子' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291875', '阳光灿烂的日子', 'In the Heat of the Sun', '夏雨 Yu Xia / 宁静 Jing Ning / 陶虹 Hong Tao', '姜文 Wen Jiang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2582946597.jpg', '剧情/爱情', '中国大陆/中国香港', NULL, 1994, NULL, NULL, NULL, 8.80, 706922, 706922, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 142: 哪吒闹海
UPDATE movie SET douban_id='1307315', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='哪吒闹海' AND release_year = 1979 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1307315', '哪吒闹海', 'Prince Nezha''s Triumph Against Dragon King / Nezha Conquers the Dragon King', '梁正晖 Zhenghui ...', '王树忱 Shuchen Wang / 严定宪 Dingxian Yan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2532803206.jpg', '冒险/动画/奇幻', '中国大陆', NULL, 1979, NULL, NULL, NULL, 9.20, 315038, 315038, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 143: 被解救的姜戈
UPDATE movie SET douban_id='6307447', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='被解救的姜戈' AND release_year = 2012 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '6307447', '被解救的姜戈', 'Django Unchained / 被解放的姜戈 / 决杀令(台)', '杰米·福克斯 Jamie Foxx /...', '昆汀·塔伦蒂诺 Quentin Tarantino', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1800813767.jpg', '剧情/动作/西部/冒险', '美国', NULL, 2012, NULL, NULL, NULL, 8.80, 707666, 707666, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 144: 侧耳倾听
UPDATE movie SET douban_id='1297052', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='侧耳倾听' AND release_year = 1995 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297052', '侧耳倾听', '耳をすませば / 心之谷(台) / 梦幻街少女(港)', '本名阳子 Youko Honna / 小林桂树 K...', '近藤喜文 Yoshifumi Kondo', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p456692072.jpg', '剧情/爱情/动画', '日本', NULL, 1995, NULL, NULL, NULL, 8.90, 529078, 529078, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 145: 幸福终点站
UPDATE movie SET douban_id='1292274', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='幸福终点站' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292274', '幸福终点站', 'The Terminal / 机场客运站(港) / 航站情缘(台)', '汤姆·汉克斯 Tom Hanks...', '史蒂文·斯皮尔伯格 Steven Spielberg', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p854757687.jpg', '喜剧/剧情/爱情', '美国', NULL, 2004, NULL, NULL, NULL, 8.80, 653364, 653364, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 146: 请以你的名字呼唤我
UPDATE movie SET douban_id='26799731', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='请以你的名字呼唤我' AND release_year = 2017 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26799731', '请以你的名字呼唤我', 'Call Me by Your Name / 以你的名字呼唤我(港 / 台)', '艾米·汉莫 Armie Hammer / ...', '卢卡·瓜达尼诺 Luca Guadagnino', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2505525050.jpg', '剧情/爱情/同性', '意大利/法国/巴西/美国', NULL, 2017, NULL, NULL, NULL, 8.80, 840762, 840762, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 147: 釜山行
UPDATE movie SET douban_id='25986180', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='釜山行' AND release_year = 2016 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25986180', '釜山行', '부산행 / 尸杀列车(港) / 尸速列车(台)', '孔刘 Yoo Gong / 郑有美 Yu-mi Jung / 马...', '延尚昊 Sang-ho Yeon', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2360940399.jpg', '动作/惊悚/灾难', '韩国', NULL, 2016, NULL, NULL, NULL, 8.60, 1373790, 1373790, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 148: 神偷奶爸
UPDATE movie SET douban_id='3287562', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='神偷奶爸' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3287562', '神偷奶爸', 'Despicable Me / 卑鄙的我 / 坏蛋奖门人(港)', '...', '皮艾尔·柯芬 Pierre Coffin / 克里斯·雷纳德 Chris Renaud', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792776858.jpg', '喜剧/动画/冒险', '美国/法国', NULL, 2010, NULL, NULL, NULL, 8.70, 1064007, 1064007, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 149: 小森林 冬春篇
UPDATE movie SET douban_id='25814707', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='小森林 冬春篇' AND release_year = 2015 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25814707', '小森林 冬春篇', 'リトル・フォレスト 冬・春 / 小森食光 / 冬春篇(台)', '桥本爱 Ai Hashimoto / 三浦贵大 Takahir...', '森淳一 Junichi Mori', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2258078370.jpg', '剧情', '日本', NULL, 2015, NULL, NULL, NULL, 9.00, 427206, 427206, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 150: 喜宴
UPDATE movie SET douban_id='1303037', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='喜宴' AND release_year = 1993 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1303037', '喜宴', '囍宴 / The Wedding Banquet', '赵文瑄 Winston Chao / 归亚蕾 Ya-lei Kuei / 郎...', '李安 Ang Lee', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2249048907.jpg', '剧情/喜剧/爱情/同性/家庭', '中国台湾/美国', NULL, 1993, NULL, NULL, NULL, 9.00, 443646, 443646, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 151: 萤火之森
UPDATE movie SET douban_id='5989818', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='萤火之森' AND release_year = 2011 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '5989818', '萤火之森', '蛍火の杜へ / 萤火之社 / Hotarubi no mori e', '佐仓绫音 Ayane Sakura / 内山昂辉 K...', '大森贵弘 Takahiro Omori', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1675053073.jpg', '剧情/爱情/动画/奇幻', '日本', NULL, 2011, NULL, NULL, NULL, 8.80, 623996, 623996, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 152: 告白
UPDATE movie SET douban_id='4268598', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='告白' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '4268598', '告白', '自白 / 母亲', '松隆子 Takako Matsu / 冈田将生 ...', '中岛哲也 Tetsuya Nakashima', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p689520756.jpg', '剧情/悬疑', '日本', NULL, 2010, NULL, NULL, NULL, 8.80, 755843, 755843, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 153: 机器人之梦
UPDATE movie SET douban_id='35426925', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='机器人之梦' AND release_year = 2023 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '35426925', '机器人之梦', 'Robot Dreams / 再见机器人(台) / 汪汪梦里人(港)', '伊万·拉班达 Ivan Labanda', '巴勃罗·贝格尔 Pablo Berger', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2928203369.jpg', '剧情/动画/音乐', '西班牙/法国', NULL, 2023, NULL, NULL, NULL, 9.10, 467400, 467400, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 154: 七武士
UPDATE movie SET douban_id='1295399', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='七武士' AND release_year = 1954 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1295399', '七武士', '七人の侍 / 七侠四义(港) / 七剑客(港)', '三船敏郎 Toshirô Mifune / 志村乔 ...', '黑泽明 Akira Kurosawa', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2215886505.jpg', '动作/冒险/剧情', '日本', NULL, 1954, NULL, NULL, NULL, 9.30, 242177, 242177, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 155: 头号玩家
UPDATE movie SET douban_id='4920389', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='头号玩家' AND release_year = 2018 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '4920389', '头号玩家', 'Ready Player One / 玩家一号 / 挑战者1号(港)', '泰伊·谢里丹 Tye Sheri...', '史蒂文·斯皮尔伯格 Steven Spielberg', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2516578307.jpg', '动作/科幻/冒险', '美国', NULL, 2018, NULL, NULL, NULL, 8.60, 1541155, 1541155, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 156: 玛丽和麦克斯
UPDATE movie SET douban_id='3072124', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='玛丽和麦克斯' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3072124', '玛丽和麦克斯', 'Mary and Max / 玛丽和马克思 / 巧克力情缘(台)', '托妮·科莱特 Toni Collette / 菲利...', '亚当·艾略特 Adam Elliot', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2923412445.jpg', '剧情/喜剧/动画', '澳大利亚/美国', NULL, 2009, NULL, NULL, NULL, 8.90, 478183, 478183, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 157: 模仿游戏
UPDATE movie SET douban_id='10463953', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='模仿游戏' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '10463953', '模仿游戏', 'The Imitation Game / 解码游戏(港) / 模拟游戏', '本尼迪克特·康伯巴奇 Benedict C...', '莫滕·泰杜姆 Morten Tyldum', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2922986728.jpg', '剧情/传记/战争/同性', '英国/美国', NULL, 2014, NULL, NULL, NULL, 8.80, 731016, 731016, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 158: 心灵奇旅
UPDATE movie SET douban_id='24733428', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='心灵奇旅' AND release_year = 2020 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '24733428', '心灵奇旅', 'Soul / 灵魂奇遇记(港) / 灵魂急转弯(台)', '杰米·...', '彼特·道格特 Pete Docter / 凯普·鲍尔斯 Kemp Powers', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2595591069.jpg', '动画/奇幻/音乐', '美国', NULL, 2020, NULL, NULL, NULL, 8.70, 1166039, 1166039, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 159: 惊魂记
UPDATE movie SET douban_id='1293181', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='惊魂记' AND release_year = 1960 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293181', '惊魂记', 'Psycho / 精神病患者 / 触目惊心(港)', '安东尼·博金斯 Antho...', '阿尔弗雷德·希区柯克 Alfred Hitchcock', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1021883305.jpg', '悬疑/惊悚/恐怖', '美国', NULL, 1960, NULL, NULL, NULL, 9.00, 366096, 366096, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 160: 大鱼
UPDATE movie SET douban_id='1291545', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='大鱼' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291545', '大鱼', 'Big Fish / 大鱼奇缘(港) / 大智若鱼(台)', '伊万·麦克格雷格 Ewan McGregor / 阿...', '蒂姆·波顿 Tim Burton', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p692813374.jpg', '剧情/爱情/奇幻/冒险', '美国', NULL, 2003, NULL, NULL, NULL, 8.80, 636079, 636079, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 161: 背靠背，脸对脸
UPDATE movie SET douban_id='1307856', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='背靠背，脸对脸' AND release_year = 1994 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1307856', '背靠背，脸对脸', '背对背，脸对脸 / Back to Back, Face to Face', '牛振华 Zhenhua N...', '黄建新 Jianxin Huang / 杨亚洲 Yazhou Yang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2505048077.jpg', '剧情', '中国大陆/中国香港', NULL, 1994, NULL, NULL, NULL, 9.40, 187126, 187126, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 162: 你的名字。
UPDATE movie SET douban_id='26683290', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='你的名字。' AND release_year = 2016 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26683290', '你的名字。', '君の名は。 / 你的名字 / 君之名', '神木隆之介 Ryûnosuke Kamiki / 上...', '新海诚 Makoto Shinkai', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p2910701461.jpg', '剧情/爱情/动画', '日本', NULL, 2016, NULL, NULL, NULL, 8.50, 1621593, 1621593, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 163: 血战钢锯岭
UPDATE movie SET douban_id='26325320', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='血战钢锯岭' AND release_year = 2016 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26325320', '血战钢锯岭', 'Hacksaw Ridge / 钢锯岭 / 钢铁英雄(台)', '安德鲁·加菲尔德 Andrew Garfield /...', '梅尔·吉布森 Mel Gibson', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2398141939.jpg', '剧情/传记/历史/战争', '澳大利亚/美国', NULL, 2016, NULL, NULL, NULL, 8.70, 873294, 873294, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 164: 高山下的花环
UPDATE movie SET douban_id='1422283', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='高山下的花环' AND release_year = 1984 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1422283', '高山下的花环', '卫国军魂(港) / Wreaths at the Foot of the Mountain', '吕晓禾 Xiaohe Lü / 唐国强 Guoqiang Tang / 何...', '谢晋 Jin Xie', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2319879389.jpg', '中国大陆', '1985', NULL, 1984, NULL, NULL, NULL, 9.50, 170633, 170633, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 165: 末路狂花
UPDATE movie SET douban_id='1291992', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='末路狂花' AND release_year = 1991 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291992', '末路狂花', 'Thelma & Louise / 塞尔玛与路易丝', '吉娜·戴维斯 Geena Davis / 苏...', '雷德利·斯科特 Ridley Scott', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1910924635.jpg', '剧情/喜剧/犯罪', '美国/英国/法国', NULL, 1991, NULL, NULL, NULL, 9.00, 363772, 363772, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 166: 射雕英雄传之东成西就
UPDATE movie SET douban_id='1316510', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='射雕英雄传之东成西就' AND release_year = 1993 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1316510', '射雕英雄传之东成西就', '射鵰英雄傳之東成西就 / 东成西就 / 大英雄 (日本)', '梁朝伟 Tony Leung Chiu Wai / 林青霞 Bri...', '刘镇伟 Jeffrey Lau', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2609063922.jpg', '喜剧/奇幻/武侠/古装', '中国香港', NULL, 1993, NULL, NULL, NULL, 8.70, 729023, 729023, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 167: 我是山姆
UPDATE movie SET douban_id='1306861', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='我是山姆' AND release_year = 2001 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1306861', '我是山姆', 'I Am Sam / 不一样的爸爸(港) / 他不笨，他是我爸爸(台)', 'Sean Penn / Dakota Fanning / Mi...', '杰茜·尼尔森 Jessie Nelson', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p652417775.jpg', '剧情/家庭', '美国', NULL, 2001, NULL, NULL, NULL, 9.00, 384213, 384213, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 168: 阳光姐妹淘
UPDATE movie SET douban_id='4917726', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='阳光姐妹淘' AND release_year = 2011 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '4917726', '阳光姐妹淘', '써니 / 阳光姊妹淘(港) / 桑尼', '沈恩京 Eun-kyung Shim / 闵孝琳 Hy...', '姜炯哲 Hyeong-Cheol Kang', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1374786017.jpg', '剧情/喜剧', '韩国', NULL, 2011, NULL, NULL, NULL, 8.80, 647464, 647464, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 169: 黑客帝国3：矩阵革命
UPDATE movie SET douban_id='1302467', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='黑客帝国3：矩阵革命' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1302467', '黑客帝国3：矩阵革命', 'The Matrix Revolutions / 22世纪杀人网络3：惊变世纪(港) / 骇客任务完结篇：最后战役(台)', NULL, '拉娜·沃卓斯基 Lana Wachowski / 莉莉·沃卓斯基 Lilly Wachowski ...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p443461818.jpg', '动作/科幻', '美国', NULL, 2003, NULL, NULL, NULL, 8.80, 506054, 506054, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 170: 恐怖直播
UPDATE movie SET douban_id='21360417', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='恐怖直播' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '21360417', '恐怖直播', '더 테러 라이브 / 死亡“动”新闻(港) / 恐怖攻击直播(台)', '河正宇 Jung-woo Ha / 李璟荣 Kyeong-y...', '金秉祐 Byeong-woo Kim', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2016930906.jpg', '剧情/犯罪/悬疑', '韩国', NULL, 2013, NULL, NULL, NULL, 8.70, 740058, 740058, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 171: 谍影重重3
UPDATE movie SET douban_id='1578507', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='谍影重重3' AND release_year = 2007 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1578507', '谍影重重3', 'The Bourne Ultimatum / 叛谍追击3：最后通牒(港) / 神鬼认证：最后通牒 (台)', '马特·达蒙 Matt Damon / ...', '保罗·格林格拉斯 Paul Greengrass', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p792223507.jpg', '动作/悬疑/惊悚', '美国/德国/法国/英国', NULL, 2007, NULL, NULL, NULL, 8.90, 481762, 481762, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 172: 小丑
UPDATE movie SET douban_id='27119724', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='小丑' AND release_year = 2019 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '27119724', '小丑', 'Joker / 小丑起源电影：罗密欧 / Romeo', '杰昆·菲尼克斯 Joaquin Phoeni...', '托德·菲利普斯 Todd Phillips', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2567198874.jpg', '剧情/犯罪/惊悚', '美国/加拿大', NULL, 2019, NULL, NULL, NULL, 8.70, 1140395, 1140395, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 173: 无间道2
UPDATE movie SET douban_id='1307106', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='无间道2' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1307106', '无间道2', '無間道II / 无间道前传 / Infernal Affairs II', '陈冠希 Edison Chen / ...', '刘伟强 Andrew Lau / 麦兆辉 Alan Mak', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p958008320.jpg', '剧情/犯罪/惊悚', '中国香港', NULL, 2003, NULL, NULL, NULL, 8.80, 581545, 581545, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 174: 三块广告牌
UPDATE movie SET douban_id='26611804', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='三块广告牌' AND release_year = 2017 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '26611804', '三块广告牌', 'Three Billboards Outside Ebbing, Missouri / 广告牌杀人事件(港) / 意外(台)', '弗兰西斯·麦克多蒙德 France...', '马丁·麦克唐纳 Martin McDonagh', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2502943384.jpg', '剧情/犯罪', '英国/美国', NULL, 2017, NULL, NULL, NULL, 8.70, 934861, 934861, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 175: 电锯惊魂
UPDATE movie SET douban_id='1417598', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='电锯惊魂' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1417598', '电锯惊魂', 'Saw / 恐惧斗室(港) / 夺魂锯(台)', '雷·沃纳尔 Leigh Whannell / 加利·艾...', '詹姆斯·温 James Wan', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p726839485.jpg', '悬疑/惊悚/恐怖', '美国', NULL, 2004, NULL, NULL, NULL, 8.70, 626736, 626736, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 176: 达拉斯买家俱乐部
UPDATE movie SET douban_id='1793929', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='达拉斯买家俱乐部' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1793929', '达拉斯买家俱乐部', 'Dallas Buyers Club / 续命枭雄(港) / 药命俱乐部(台)', '马修·麦康纳 Matthew McCon...', '让-马克·瓦雷 Jean-Marc Vallée', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2166160837.jpg', '剧情/传记/同性', '美国', NULL, 2013, NULL, NULL, NULL, 8.80, 515105, 515105, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 177: 疯狂原始人
UPDATE movie SET douban_id='1907966', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='疯狂原始人' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1907966', '疯狂原始人', 'The Croods / 古鲁家族(港 / 台)', NULL, '科克·德·米科 Kirk De Micco / 克里斯·桑德斯 Chris Sanders 主演...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1867084027.jpg', '喜剧/动画/冒险', '美国', NULL, 2013, NULL, NULL, NULL, 8.70, 935224, 935224, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 178: 疯狂的石头
UPDATE movie SET douban_id='1862151', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='疯狂的石头' AND release_year = 2006 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1862151', '疯狂的石头', 'Crazy Stone', '郭涛 Tao Guo / 刘桦 Hua Liu / 连晋 Teddy Lin', '宁浩 Hao Ning', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p712241453.jpg', '喜剧/犯罪', '中国大陆/中国香港', NULL, 2006, NULL, NULL, NULL, 8.60, 942949, 942949, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 179: 绿里奇迹
UPDATE movie SET douban_id='1300374', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='绿里奇迹' AND release_year = 1999 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1300374', '绿里奇迹', 'The Green Mile / 绿色奇迹(台) / 绿色英里', '汤姆·汉克斯 Tom Hanks / ...', '弗兰克·德拉邦特 Frank Darabont', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p767586451.jpg', '犯罪/剧情/奇幻/悬疑', '美国', NULL, 1999, NULL, NULL, NULL, 8.90, 397083, 397083, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 180: 雨中曲
UPDATE movie SET douban_id='1293460', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='雨中曲' AND release_year = 1952 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1293460', '雨中曲', 'Singin'' in the Rain / 万花嬉春(港 / 台)', '吉恩·...', '斯坦利·多南 Stanley Donen / 吉恩·凯利 Gene Kelly', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1612355875.jpg', '喜剧/歌舞/爱情', '美国', NULL, 1952, NULL, NULL, NULL, 9.10, 275921, 275921, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 181: 爱在午夜降临前
UPDATE movie SET douban_id='10808442', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='爱在午夜降临前' AND release_year = 2013 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '10808442', '爱在午夜降临前', 'Before Midnight / 情约半生(港) / 爱在午夜希腊时(台)', '伊桑·霍克 Ethan Hawke ...', '理查德·林克莱特 Richard Linklater', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2074715729.jpg', '剧情/爱情', '美国/希腊', NULL, 2013, NULL, NULL, NULL, 8.80, 486906, 486906, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 182: 2001太空漫游
UPDATE movie SET douban_id='1292226', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='2001太空漫游' AND release_year = 1968 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292226', '2001太空漫游', '2001: A Space Odyssey / 2001：星际漫游 / 2001：太空奥德赛', '凯尔·杜拉 Keir Dullea / ...', '斯坦利·库布里克 Stanley Kubrick', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2926647970.jpg', '科幻/惊悚/冒险', '英国/美国', NULL, 1968, NULL, NULL, NULL, 8.90, 408449, 408449, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 183: 海街日记
UPDATE movie SET douban_id='25895901', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='海街日记' AND release_year = 2015 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25895901', '海街日记', '海街diary / 海街女孩日记(港) / Kamakura Diary', '绫濑遥 Haruka Ayase / 长泽雅美 M...', '是枝裕和 Hirokazu Koreeda', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2242546753.jpg', '剧情/家庭', '日本', NULL, 2015, NULL, NULL, NULL, 8.80, 534857, 534857, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 184: 上帝之城
UPDATE movie SET douban_id='1292208', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='上帝之城' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292208', '上帝之城', 'Cidade de Deus / 无主之城(港) / 无法无天(台)', NULL, '费尔南多·梅里尔斯 Fernando Meirelles / 卡迪亚·兰德 Kátia Lund ...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p455677490.jpg', '犯罪/剧情', '巴西/法国', NULL, 2002, NULL, NULL, NULL, 9.00, 339120, 339120, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 185: 心迷宫
UPDATE movie SET douban_id='25917973', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='心迷宫' AND release_year = 2014 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '25917973', '心迷宫', '殡棺 / The Coffin in the Mountain', '霍卫民 Weimin Huo / 王笑天 Xiaotian Wang ...', '忻钰坤 Yukun Xin', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2926020289.jpg', '剧情/犯罪/悬疑', '中国大陆', NULL, 2014, NULL, NULL, NULL, 8.70, 631457, 631457, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 186: 风之谷
UPDATE movie SET douban_id='1291585', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='风之谷' AND release_year = 1984 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291585', '风之谷', '風の谷のナウシカ / 风谷少女 / Kaze no tani no Naushika', '岛本须美 Sumi Shimamoto / 松田洋治 Y...', '宫崎骏 Hayao Miyazaki', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1917567652.jpg', '动画/奇幻/冒险', '日本', NULL, 1984, NULL, NULL, NULL, 8.90, 399547, 399547, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 187: 记忆碎片
UPDATE movie SET douban_id='1304447', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='记忆碎片' AND release_year = 2000 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1304447', '记忆碎片', 'Memento / 凶心人(港) / 记忆拼图(台)', '盖·皮尔斯 Guy Pearce /...', '克里斯托弗·诺兰 Christopher Nolan', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2931989223.jpg', '犯罪/剧情/悬疑/惊悚', '美国', NULL, 2000, NULL, NULL, NULL, 8.70, 723980, 723980, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 188: 英雄本色
UPDATE movie SET douban_id='1297574', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='英雄本色' AND release_year = 1986 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297574', '英雄本色', 'A Better Tomorrow / Gangland Boss', '周润发 Yun-Fat Chow / 狄龙 Lung Ti / 张国...', '吴宇森 John Woo', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2504997087.jpg', '剧情/动作/犯罪', '中国香港', NULL, 1986, NULL, NULL, NULL, 8.60, 617190, 617190, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 189: 纵横四海
UPDATE movie SET douban_id='1295409', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='纵横四海' AND release_year = 1991 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1295409', '纵横四海', '縱橫四海 / Once a Thief', '周润发 Yun-Fat Chow / 张国荣 Leslie Cheung...', '吴宇森 John Woo', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2931740648.jpg', '剧情/喜剧/动作/犯罪', '中国香港', NULL, 1991, NULL, NULL, NULL, 8.80, 497330, 497330, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 190: 恐怖游轮
UPDATE movie SET douban_id='3011051', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='恐怖游轮' AND release_year = 2009 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3011051', '恐怖游轮', 'Triangle / 汪洋血迷宮(台) / 轮回三角', '梅利莎·乔治 Melissa ...', '克里斯托弗·史密斯 Christopher Smith', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2933909877.jpg', '科幻/悬疑/奇幻/惊悚', '英国/澳大利亚', NULL, 2009, NULL, NULL, NULL, 8.50, 1060070, 1060070, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 191: 无敌破坏王
UPDATE movie SET douban_id='6534248', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='无敌破坏王' AND release_year = 2012 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '6534248', '无敌破坏王', 'Wreck-It Ralph / 破坏王拉尔夫 / 破坏王大冒险', '约翰·C·赖利 John C. Reilly / 萨拉...', '瑞奇·莫尔 Rich Moore', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p1735642656.jpg', '喜剧/动画/奇幻/冒险', '美国', NULL, 2012, NULL, NULL, NULL, 8.70, 623263, 623263, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 192: 芙蓉镇
UPDATE movie SET douban_id='1297880', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='芙蓉镇' AND release_year = 1987 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1297880', '芙蓉镇', 'Hibiscus Town', '刘晓庆 Xiaoqing Liu / 姜文 Wen Jiang / 郑在石...', '谢晋 Jin Xie', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2575337180.jpg', '剧情/爱情', '中国大陆', NULL, 1987, NULL, NULL, NULL, 9.30, 198491, 198491, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 193: 魔女宅急便
UPDATE movie SET douban_id='1307811', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='魔女宅急便' AND release_year = 1989 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1307811', '魔女宅急便', '魔女の宅急便 / 魔女琪琪(台) / 小魔女限时专送', '高山南 Minami Takayama / 佐久间玲 Re...', '宫崎骏 Hayao Miyazaki', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p456676352.jpg', '动画/奇幻/冒险', '日本', NULL, 1989, NULL, NULL, NULL, 8.80, 535259, 535259, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 194: 牯岭街少年杀人事件
UPDATE movie SET douban_id='1292329', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='牯岭街少年杀人事件' AND release_year = 1991 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1292329', '牯岭街少年杀人事件', '牯嶺街少年殺人事件 / A Brighter Summer Day', '张震 Chen Chang / 杨静怡 Lisa Yang / 张...', '杨德昌 Edward Yang', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p848381236.jpg', '剧情/犯罪', '中国台湾', NULL, 1991, NULL, NULL, NULL, 8.90, 381529, 381529, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 195: 小偷家族
UPDATE movie SET douban_id='27622447', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='小偷家族' AND release_year = 2018 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '27622447', '小偷家族', '万引き家族 / Shoplifters / Une Affaire de Famille', '中川雅也 Lily Franky / 安藤樱 Sa...', '是枝裕和 Hirokazu Koreeda', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2530599636.jpg', '剧情/犯罪/家庭', '日本', NULL, 2018, NULL, NULL, NULL, 8.70, 907909, 907909, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 196: 东京教父
UPDATE movie SET douban_id='1310177', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='东京教父' AND release_year = 2003 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1310177', '东京教父', '東京ゴッドファーザーズ / Tokyo Godfathers', '江守彻 Toru Emori / 梅垣义明 Yoshiaki Ume...', '今敏 Satoshi Kon', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2066810983.jpg', '剧情/喜剧/动画', '日本', NULL, 2003, NULL, NULL, NULL, 9.00, 299700, 299700, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 197: 卢旺达饭店
UPDATE movie SET douban_id='1291822', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='卢旺达饭店' AND release_year = 2004 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291822', '卢旺达饭店', 'Hotel Rwanda / 卢安达饭店(台)', '唐·钱德尔 Don Cheadle / 苏菲·奥...', '特瑞·乔治 Terry George', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p470419493.jpg', '剧情/传记/历史/战争', '英国/南非/意大利/美国', NULL, 2004, NULL, NULL, NULL, 8.90, 374463, 374463, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 198: 冰川时代
UPDATE movie SET douban_id='1291578', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='冰川时代' AND release_year = 2002 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1291578', '冰川时代', 'Ice Age / 冰河世纪 / 冰原历险记', NULL, '卡洛斯·沙尔丹哈 Carlos Saldanha / 克里斯·韦奇 Chris Wedge 主演...', 'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p1910895719.jpg', '喜剧/动画/冒险', '美国', NULL, 2002, NULL, NULL, NULL, 8.70, 696736, 696736, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 199: 忠犬八公物语
UPDATE movie SET douban_id='1959195', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='忠犬八公物语' AND release_year = 1987 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '1959195', '忠犬八公物语', 'ハチ公物語 / 八千公物语 / 阿八的故事', '仲代达矢 Tatsuya Nakadai /...', '神山征二郎 Seijirô Kôyama', 'https://img9.doubanio.com/view/photo/s_ratio_poster/public/p2603716224.jpg', '剧情', '日本', NULL, 1987, NULL, NULL, NULL, 9.20, 223015, 223015, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

-- Top 200: 岁月神偷
UPDATE movie SET douban_id='3792799', updated_at=UTC_TIMESTAMP(6) WHERE douban_id IS NULL AND name='岁月神偷' AND release_year = 2010 LIMIT 1;
INSERT INTO movie (douban_id, name, alias, actors, directors, cover, genres, regions, languages, release_year, release_date, mins, storyline, score, rating_count, popularity, status, created_at, updated_at) VALUES (
    '3792799', '岁月神偷', '歲月神偷 / 1969太空漫游 / Echoes Of The Rainbow', '吴君如 Sandra Ng / 任达华 Simon Yam / 钟绍...', '罗启锐 Alex Law', 'https://img2.doubanio.com/view/photo/s_ratio_poster/public/p456666151.jpg', '剧情/家庭', '中国香港/中国大陆', NULL, 2010, NULL, NULL, NULL, 8.70, 619069, 619069, 'AVAILABLE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
ON DUPLICATE KEY UPDATE name=VALUES(name), alias=VALUES(alias), actors=VALUES(actors), directors=VALUES(directors), cover=VALUES(cover), genres=VALUES(genres), regions=VALUES(regions), release_year=VALUES(release_year), score=VALUES(score), rating_count=VALUES(rating_count), popularity=VALUES(popularity), status='AVAILABLE', updated_at=UTC_TIMESTAMP(6);

COMMIT;
