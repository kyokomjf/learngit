package org.maojf.searchusers;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

public class AjaxServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 设置返回字符编码
		response.setCharacterEncoding("UTF-8");
		String sort = request.getParameter("sort");
		// 初始化数据
		// 1 | andy | | Andy
		// 2 | carl | | Carl
		// 3 | bruce | | Bruce
		// 4 | dolly | | Dolly
		UserInfo user1 = new UserInfo(1, "andy", "", "Andy");
		UserInfo user2 = new UserInfo(2, "carl", "", "Carl");
		UserInfo user3 = new UserInfo(3, "bruce", "", "Bruce");
		UserInfo user4 = new UserInfo(4, "dolly", "", "Dolly");

		List list = new ArrayList();
		list.add(user1);
		list.add(user2);
		list.add(user3);
		list.add(user4);

		if (!sort.equals("")) {
			String px[]=sort.split("_");
			if(px.length>1){
				String sort_col=px[0];
				String sort_method=px[1];
				boolean reverseFlag=false;
				if(sort_method.equals("asc"))
					reverseFlag=false;
				else
					reverseFlag=true;
				
				sortByMethod(list,sort_col,reverseFlag);
			}
			
		}

		JSONArray jsonArray = new JSONArray();

		jsonArray = JSONArray.fromObject(list);
		PrintWriter out = null;

		try {
			out = response.getWriter();

			out.write(jsonArray.toString());
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (out != null) {
					out.close();
				}
			} catch (Exception e) {
			}
		}
	}
	
	public void sortByMethod(List<Object> list, final String method,
            final boolean reverseFlag) {
        Collections.sort(list, new Comparator<Object>() {
            @SuppressWarnings("unchecked")
            public int compare(Object arg1, Object arg2) {
                int result = 0;
                try {
                    Method m1 = ((Object) arg1).getClass().getMethod(method, null);
                    Method m2 = ((Object) arg2).getClass().getMethod(method, null);
                    Object obj1 = m1.invoke(((Object)arg1), null);
                    Object obj2 = m2.invoke(((Object)arg2), null);
                    if(obj1 instanceof String) {
                        // 字符串
                        result = obj1.toString().compareTo(obj2.toString());
                    }else if(obj1 instanceof Date) {
                        // 日期
                        long l = ((Date)obj1).getTime() - ((Date)obj2).getTime();
                        if(l > 0) {
                            result = 1;
                        }else if(l < 0) {
                            result = -1;
                        }else {
                            result = 0;
                        }
                    }else if(obj1 instanceof Integer) {
                        result = (Integer)obj1 - (Integer)obj2;
                    }else if(obj1 instanceof Long) {
                        result = Integer.parseInt(String.valueOf((Long)obj1 - (Long)obj2));
                    }
                    else { 
                        result = obj1.toString().compareTo(obj2.toString());
                        
                        System.err.println("sortByMethod方法接受到不可识别的对象类型，转换为字符串后比较返回...");
                    }
                    
                    if (reverseFlag) {
                        // 倒序
                        result = -result;
                    }
                } catch (NoSuchMethodException nsme) {
                    nsme.printStackTrace();
                } catch (IllegalAccessException iae) {
                    iae.printStackTrace();
                } catch (InvocationTargetException ite) {
                    ite.printStackTrace();
                }

                return result;
            }
        });
    }

}
