public Class GokulG {
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
}