import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Objects;
import java.util.logging.Logger;

public class AuthUtil {

    private static final Logger LOGGER = Logger.getLogger(AuthUtil.class.getName());
    public static HashMap<String, HashMap<String, Object>> tokenData = new HashMap<>();

    private String clientId = null;

    public AuthUtil(String clientID, String clientSecret, String refreshToken) {
        this.clientId = clientID;
        if(!tokenData.containsKey(clientID)) {
            HashMap<String, Object> data = new HashMap<>();
            data.put("clientID", clientID);
            data.put("clientSecret", clientSecret);
            data.put("refreshToken", refreshToken);
            data.put("accessToken", "");
            data.put("expiresIn", LocalDateTime.now());
            tokenData.put(clientID,data);
        }
    }


    public synchronized String access_token() throws Exception {

        if(Objects.nonNull(this.clientId) && tokenData.containsKey(this.clientId)) {
            HashMap<String, Object> data = tokenData.get(this.clientId);
            LocalDateTime expiresIn = (LocalDateTime) data.get("expiresIn");
            if(expiresIn.isBefore(LocalDateTime.now().plusSeconds(10))) {
                URIBuilder uriBuilder = new URIBuilder()
                        .setScheme("https")
                        .setHost("accounts.zoho.com")
                        .setPath("/oauth/v2/token")
                        .setParameter("client_id", data.get("clientID").toString())
                        .setParameter("client_secret", data.get("clientSecret").toString())
                        .setParameter("refresh_token", data.get("refreshToken").toString())
                        .setParameter("grant_type", "refresh_token");
                LOGGER.info("OAuth token refresh URL: "+ uriBuilder.toString());
                int timeout = 300000; // 5 Minutes
                RequestConfig requestConfig = RequestConfig.custom().setConnectTimeout(timeout)
                        .setConnectionRequestTimeout(timeout).setSocketTimeout(timeout).build();
                try(CloseableHttpClient httpClient = HttpClientBuilder
                        .create().setDefaultRequestConfig(requestConfig).build()) {

                    HttpPost httpPost = new HttpPost(uriBuilder.build());
                    String response = EntityUtils.toString((httpClient.execute(httpPost)).getEntity());
                    httpPost.releaseConnection();
                    JSONObject responseJson = new JSONObject(response.substring(response.indexOf("{"), response.length()));
                    int expiresInt = responseJson.has("expires_in_sec")
                            ? responseJson.getInt("expires_in_sec") : responseJson.getInt("expires_in");
                    data.put("expiresIn",LocalDateTime.now().plusSeconds(expiresInt));
                    data.put("accessToken",responseJson.getString("access_token"));
                }
            }
            return tokenData.get(clientId).get("accessToken").toString();
        } else {
            throw new Exception("OAuth details not initialized");
        }
    }
}