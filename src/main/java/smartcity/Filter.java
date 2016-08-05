package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import javax.servlet.http.HttpServletRequest;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Created by minchu on 15/04/16.
 */
public class Filter {
    public String parameter;
    public String parameterValue;
    public String parameterPresentable;
    public String parameterValuePresentable;

    public static Set<Filter> FILTERS = new LinkedHashSet<>();

    public Filter(String p, String pV, String pP, String queryKey) {
        this.parameter = p;
        this.parameterValue = pV;
        this.parameterPresentable = pP;

        BasicDBObject parameterValuePresentableObject = new BasicDBObject();
        boolean isNumeric = pV.matches("[0-9]+");
        if (isNumeric) {
            parameterValuePresentableObject.put(queryKey, Integer.parseInt(pV));
        } else if (!isNumeric) {
            parameterValuePresentableObject.put(queryKey, pV);
        }
        DBCursor cursor = Database.allworks.find(parameterValuePresentableObject);

        while (cursor.hasNext()) {
            DBObject object = cursor.next();
            this.parameterValuePresentable = object.get(pP).toString();
            break;
        }
    }

    /**
     * Generates filters hash set given the http request.
     *
     * @param request
     * @return
     */
    public static BasicDBObject generateFiltersHashset(HttpServletRequest request) {

        String wardNumberParameter = request.getParameter("wardNumber");
        String statusParameter = request.getParameter("status");
        String workTypeIDParameter = request.getParameter("workTypeID");
        String contractorIDParameter = request.getParameter("contractorID");
        String sourceOfIncomeIDParameter = request.getParameter("sourceOfIncomeID");
        //String languageParameter = request.getParameter("language");
        String yearParameter = request.getParameter("year");
        String minorIDParameter = request.getParameter("minorID");

        FILTERS.clear();
        BasicDBObject myQuery = new BasicDBObject();

        if (wardNumberParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.WardNumber"), Integer.parseInt(wardNumberParameter));

            Filter click = new Filter("wardNumber", wardNumberParameter, LoadProperties.properties.getString("Work.Column.WardNumber"), LoadProperties.properties.getString("Work.Column.WardNumber"));
            FILTERS.add(click);
        }

        if (statusParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.Status"), statusParameter);

            Filter click = new Filter("status", statusParameter, LoadProperties.properties.getString("Work.Column.Status"), LoadProperties.properties.getString("Work.Column.Status"));
            FILTERS.add(click);
        }

        if (workTypeIDParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.WorkTypeID"), Integer.parseInt(workTypeIDParameter));

            Filter click = new Filter("workTypeID", workTypeIDParameter, LoadProperties.properties.getString("Work.Column.WorkType"), LoadProperties.properties.getString("Work.Column.WorkTypeID"));
            FILTERS.add(click);
        }

        if (contractorIDParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.ContractorID"), Integer.parseInt(contractorIDParameter));

            Filter click = new Filter("contractorID", contractorIDParameter, LoadProperties.properties.getString("Work.Column.Contractor"), LoadProperties.properties.getString("Work.Column.ContractorID"));
            FILTERS.add(click);
        }

        if (sourceOfIncomeIDParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"), Integer.parseInt(sourceOfIncomeIDParameter));

            Filter click = new Filter("sourceOfIncomeID", sourceOfIncomeIDParameter, LoadProperties.properties.getString("Work.Column.SourceOfFinance"), LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"));
            FILTERS.add(click);
        }

        if (yearParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.Year"), Integer.parseInt(yearParameter));

            Filter click = new Filter("year", yearParameter, LoadProperties.properties.getString("Work.Column.Year"), LoadProperties.properties.getString("Work.Column.Year"));
            FILTERS.add(click);
        }

        if (minorIDParameter != null) {
            myQuery.put(LoadProperties.properties.getString("Work.Column.MinorWorkTypeID"), Integer.parseInt(minorIDParameter));

            Filter click = new Filter("minorID", minorIDParameter, LoadProperties.properties.getString("Work.Column.MinorWorkTypeIDMeaning"), LoadProperties.properties.getString("Work.Column.MinorWorkTypeID"));
            FILTERS.add(click);
        }

        return myQuery;
    }

    public static String getFiltersApplied() {
        Iterator filtersApplied = smartcity.Filter.FILTERS.iterator();

        String filters = "";

        while (filtersApplied.hasNext()) {
            Filter click = (Filter) filtersApplied.next();
            filters = filters + click.parameterPresentable + " : " + click.parameterValuePresentable + " ";
            break;
        }

        while (filtersApplied.hasNext()) {
            Filter click = (Filter) filtersApplied.next();
            filters = filters + " & " + click.parameterPresentable + " : " + click.parameterValuePresentable + " ";
        }

        return filters;
    }
}