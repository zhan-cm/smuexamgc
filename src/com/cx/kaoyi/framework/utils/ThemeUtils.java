package com.cx.kaoyi.framework.utils;

import com.cx.kaoyi.business.domain.Theme;
import java.util.*;

public class ThemeUtils {
    /**
     * 将【树结构】按叶子节点平铺为 List<Map<String,String>>。
     * 每条 Map 只对应一个叶子节点，
     * theme1/2/3 的 id 与 name 采用 “theme{i}id / theme{i}name” 的命名，
     * 不存在的层级填 null。
     */
    public static List<Map<String, String>> flattenLeafToMaps(List<Theme> rootThemes) {
        List<Map<String, String>> result = new ArrayList<>();
        if (rootThemes == null) return result;

        for (Theme t1 : rootThemes) {
            Map<String, String> prefix = new HashMap<>();
            prefix.put("theme1Id", longToStr(t1.getId()));
            prefix.put("theme1Name", t1.getName());
            dfsFlatten(t1, 1, prefix, result);
        }
        return result;
    }

    private static void dfsFlatten(Theme node,
                                   int level,
                                   Map<String, String> path,
                                   List<Map<String, String>> out) {

        Map<String, String> cur = new HashMap<>(path);

        if (level == 2) {
            cur.put("theme2Id", longToStr(node.getId()));
            cur.put("theme2Name", node.getName());
        } else if (level == 3) {
            cur.put("theme3Id", longToStr(node.getId()));
            cur.put("theme3Name", node.getName());
        }

        List<Theme> children = node.getChildList();
        if (children == null || children.isEmpty()) {
            // 叶子：补齐缺失层
            cur.putIfAbsent("theme2Id", null);
            cur.putIfAbsent("theme2Name", null);
            cur.putIfAbsent("theme3Id", null);
            cur.putIfAbsent("theme3Name", null);
            out.add(cur);
        } else {
            for (Theme child : children) {
                dfsFlatten(child, level + 1, cur, out);
            }
        }
    }

    /**
     * 根据【全部扁平列表】构建树。
     *
     * @param allThemes   扁平的所有 Theme（可乱序）
     * @param searchPid   -1 表示组装整棵森林；否则仅返回 id = searchPid 的那棵子树
     * @return            根节点列表
     */
    public static List<Theme> buildThemeTree(List<Theme> allThemes, Long searchPid) {
        if (allThemes == null) return Collections.emptyList();

        // 先用 map 凭 id 快速索引
        Map<Long, Theme> themeMap = new HashMap<>(allThemes.size());
        for (Theme theme : allThemes) {
            themeMap.put(theme.getId(), theme);
            // 清空旧的 childList（防止重复组装）
            theme.setChildList(null);
        }

        List<Theme> roots = new ArrayList<>();
        for (Theme theme : allThemes) {
            Long pid = theme.getPid();

            // ① 找根
            boolean isRoot = (searchPid == -1 && pid == -1)
                    || (searchPid != -1 && theme.getId() == searchPid);
            if (isRoot) {
                roots.add(theme);
                continue;
            }

            // ② 组装父子
            Theme parent = themeMap.get(pid);
            if (parent != null) {
                if (parent.getChildList() == null) {
                    parent.setChildList(new ArrayList<>());
                }
                parent.getChildList().add(theme);
            }
        }
        return roots;
    }

    /**
     * 将树结构再“打散”成扁平 List<Theme>（深度优先预序遍历，不去重）。
     */
    public static List<Theme> flattenTreeToList(List<Theme> rootThemes) {
        List<Theme> result = new ArrayList<>();
        if (rootThemes == null) return result;

        Deque<Theme> stack = new ArrayDeque<>(rootThemes);
        while (!stack.isEmpty()) {
            Theme cur = stack.pop();
            result.add(cur);
            List<Theme> children = cur.getChildList();
            if (children != null && !children.isEmpty()) {
                // 逆序压栈以保持原顺序
                for (int i = children.size() - 1; i >= 0; i--) {
                    stack.push(children.get(i));
                }
            }
        }
        return result;
    }

    /* ---------- helper ---------- */
    private static String longToStr(Long v) {
        return v == null ? null : v.toString();
    }
}
