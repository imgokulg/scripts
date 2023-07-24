import org.apache.commons.codec.digest.DigestUtils;
import java.lang.reflect.Constructor;

import java.util.Random;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.RichTextString;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public Class GokulG {
    public static final Gson GSON = new GsonBuilder()
        .registerTypeAdapter(LocalDate.class, new LocalDateSerializer())
        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeSerializer())
        .registerTypeAdapter(LocalDate.class, new LocalDateDeserializer())
        .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeDeserializer())
        .setDateFormat("yyyy-MM-dd HH:mm:ss")
        .setPrettyPrinting().create();

    public static final String ZERO_TO_TWO_FIFTY_FIVE = "(\\d{1,2}|(0|1)\\" + "d{2}|2[0-4]\\d|25[0-5])";
    public static final Pattern VALID_IP_ADDRESS_REGEX =
            Pattern.compile(ZERO_TO_TWO_FIFTY_FIVE + "\\." + ZERO_TO_TWO_FIFTY_FIVE + "\\." + ZERO_TO_TWO_FIFTY_FIVE + "\\." + ZERO_TO_TWO_FIFTY_FIVE,
                    Pattern.CASE_INSENSITIVE);

    public static final Pattern VALID_DOMAIN_REGEX = Pattern.compile("^@.*\\..*");
    public static final Pattern VALID_EMAIL_ADDRESS_REGEX =
            Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,15}$", Pattern.CASE_INSENSITIVE);
            
    public static void main(String[] args){
        long startTime = System.nanoTime();
        try {
        } catch (Exception | Error e) {
            e.printStackTrace();
        }
        long endTime = System.nanoTime();
        String timerMsg = "It took " + (float) (endTime - startTime) / 1000_000_000L + " seconds<br>";
        System.out.println(timerMsg);
    }

    public Object getClass(String className){
        Class<?> clazz = Class.forName(className);
        Constructor<?> cons = clazz.getDeclaredConstructor();
        cons.setAccessible(true);
        Object object = cons.newInstance();
        //object.getClass().getDeclaredMethods()[0].invoke(object,"gokulg");
        return object;
    }

    public static String hashValueGeneratorUsingSHA(String[] values) {
        StringBuilder builder = new StringBuilder();
        for (String value : values) {
            builder.append(value);
        }
        return hashValueGeneratorUsingSHA(builder.toString());
    }
     public static String hashValueGeneratorUsingSHA(String value) {
        return DigestUtils.sha256Hex(value);
    }

    
    public static Object removeInvalidByteSequence(Object value) {
        if (value instanceof String) {
            String valueT = (String) value;
            valueT = valueT.replace("\\u0000", "");
            valueT = valueT.replace("\u0000", "");
            //valueT = valueT.replaceAll("[^\\p{ASCII}]", ""); // removes all characters other than ASCII Characters
            value = valueT;
        }
        return value;
    }


    public static void writeXlsx(String saveFilePath, List<String[]> data) throws Exception {
        Map<String, List<String[]>> writeData = new HashMap<>();
        writeData.put("Sheet1", data);
        writeXlsx(saveFilePath, writeData);
    }

    public static void writeXlsx(String saveFilePath, Map<String, List<String[]>> data) throws Exception {
        XSSFWorkbook workbook = new XSSFWorkbook();
        for (String sheetName : data.keySet()) {
            XSSFSheet sheet = workbook.createSheet(sheetName);
            int rowCount = 0;

            for (String[] rowDataValues : data.get(sheetName)) {
                Row row = sheet.createRow(rowCount++);
                writeRowData(row, rowDataValues);
            }
            try (FileOutputStream outputStream = new FileOutputStream(saveFilePath)) {
                workbook.write(outputStream);
            }

        }
    }

    
    public static void writeRowData(Row row, String[] rowDataValues) {
        int columnCount = 0;
        for (Object field : rowDataValues) {
            Cell cell = row.createCell(columnCount++);
            if (field instanceof String) {
                cell.setCellValue((String) field);
            } else if (field instanceof Boolean) {
                cell.setCellValue((Boolean) field);
            } else if (field instanceof Double) {
                cell.setCellValue((Double) field);
            } else if (field instanceof Integer) {
                cell.setCellValue((Integer) field);
            } else if (field instanceof Long) {
                cell.setCellValue((Long) field);
            } else if (field instanceof Float) {
                cell.setCellValue((Float) field);
            } else if (field instanceof Date) {
                cell.setCellValue((Date) field);
            } else if (field instanceof Calendar) {
                cell.setCellValue((Calendar) field);
            } else if (field instanceof RichTextString) {
                cell.setCellValue((RichTextString) field);
            } else {
                cell.setCellValue("" + field);
            }
        }
    }

    public static void writeCSV(List<String[]> result, String fileName) throws FileNotFoundException {
        try (PrintWriter pw = new PrintWriter(new File(fileName))) {
            result.stream()
                    .map(dataArray -> Stream.of(dataArray)
                            .map(data -> {
                                data = data + "";
                                String escapedData = data.replaceAll("\\R", " ");
                                if (data.contains(",") || data.contains("\"") || data.contains("'")) {
                                    data = data.replace("\"", "\"\"");
                                    escapedData = "\"" + data + "\"";
                                }
                                return escapedData;
                            })
                            .collect(Collectors.joining(",")))
                    .forEach(pw::println);
        }
        LOGGER.log(Level.INFO, "{0} is created", new Object[]{fileName});
    }


    public static String generateRandomString(int length) {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            sb.append(characters.charAt(index));
        }
        return sb.toString();
    }

    public static String generateRandomEmailAddress() {
        return generateRandomString(8) + "@" + generateRandomString(6) + ".com";
    }
}
