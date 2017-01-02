package smartcity;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by minchu on 07/06/16.
 */
public class HelloWorld extends HttpServlet {
    public void init(){
        System.out.println("Hello World!");

        //EveryNightScripts.updateDB();
        Contractor.createContractors();
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
