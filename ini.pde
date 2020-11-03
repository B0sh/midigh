class Ini
{
    String ini_filename;
    List<String> contents;
    Map<String, String> cache = new HashMap<String, String>();
    
    Ini(String ini_filename_)
    {
        ini_filename = ini_filename_;
        contents = Arrays.asList(loadStrings(ini_filename));
    }

    String getString(String property_name)
    {
        if (cache.containsKey(property_name))
        {
            return cache.get(property_name);
        }

        for (String line : contents)
        {
            String regex = property_name + "\\s*=\\s*(.*)$";

            String[] result = match(line, regex);
            if (result != null) 
            {
                cache.put(property_name, result[1]);
                return result[1];
            }
        }

        return null;
    }
    
    int getInt(String property_name)
    {
        return Integer.parseInt(getString(property_name));
    }

    void setString(String property_name, String value)
    {
        if (cache.containsKey(property_name))
        {
            cache.replace(property_name, value);
        }
        else 
        {
            cache.put(property_name, value);
        }
        
        for (int i = 0; i < contents.size(); i++)
        {
            String line = contents.get(i);
            String regex = property_name + "\\s*=\\s*(.*)$";

            String[] result = match(line, regex);
            if (result != null) 
            {
                contents.set(i, property_name + " = " + value);
                saveStrings(ini_filename, contents.toArray(new String[contents.size()]));
                return;
            }
        }

        contents.add(property_name + " = " + value);
        saveStrings(ini_filename, contents.toArray(new String[contents.size()]));
    }
    
    void setInt(String property_name, int value)
    {
        setString(property_name, Integer.toString(value));
    }
}