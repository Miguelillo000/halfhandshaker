from codecs import encode
import sys

file = sys.argv[2]
gived_essid = sys.argv[1]

try:
	check = sys.argv[3]
except:
	check = 0

signature = "48435058"
version = "04000000"
message_pair = "00"

def split_eapol_packets():
	f = open(file, "rb")
	byteT = f.read()
	hexT = byteT.hex()

	packet_number = 0
	packets = []

	indexes = [i for i in range(len(hexT)) if hexT.startswith("888e", i)]

	for index in indexes:

		packet_info = {}

		packet_len = hexT[index - 32 : index - 30]
		packet_len = int(packet_len, 16)
		packet = hexT[index - 24 : index - 24 + (packet_len * 2)]
		packet_info.update({"packet":packet})

		message_type = hexT[index + 14 : index + 18]
		packet_info.update({"message_type":message_type})

		packets.append(packet_info)

	return packets


def choose_pair(packets):
	first = ""
	for packet in packets:
		if first == "":
			if packet["message_type"] == "008a":
				first = packet["packet"]
			else:
				first = ""
		else:
			if packet["message_type"] == "010a":
				return [first, packet["packet"]]
			else:
				first = ""
	print("0", end="")
	exit()

def get_info(pair):
	all_info = {
		"keymic": pair[1][190:222],

		"ap_mac": pair[0][0:12],
		"ap_nonce": pair[0][62:126],

		"sta_mac": pair[0][12:24],
		"sta_nonce": pair[1][62:126],

		"eapol": pair[1][28:],
	}

	return all_info


def generate_hccapx(all_info):
	essid_len =	len(gived_essid)
	essid_len = hex(essid_len).split("x")[1]
	essid_len = essid_len.zfill(2)

	essid = encode(bytes(gived_essid, encoding='utf8'), "hex").decode("utf-8")
	while len(essid) != 64:	essid = essid + "0"

	keyver = "02"
	keymic = all_info["keymic"]

	ap_mac = all_info["ap_mac"]
	ap_nonce = all_info["ap_nonce"]

	sta_mac = all_info["sta_mac"]
	sta_nonce = all_info["sta_nonce"]

	eapol_len = "7900"
	eapol = all_info["eapol"]
	eapol = eapol.replace(keymic, "00000000000000000000000000000000")
	while len(eapol) != 512: eapol = eapol + "0"

	hccapx = signature + version + message_pair + essid_len + essid + keyver + keymic + ap_mac + ap_nonce + sta_mac + sta_nonce + eapol_len + eapol

	return hccapx

if __name__ == '__main__':
	if check != "c":
		try:
			hccapxString = generate_hccapx(get_info(choose_pair(split_eapol_packets())))
			#print(hccapxString)
			hccapxFile = open(file.split(".cap")[0] + ".hccapx", "wb")
			hccapxFile.write(bytes.fromhex(hccapxString))
			hccapxFile.close()
		except:
			print("error")
			exit()
	else:
		checking = choose_pair(split_eapol_packets())
		print("1", end="")